//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//
//  Additions for new transaction types by Mark Loit 2022

import Foundation
import BigInt

/// Structure capable of carying the parameters for any transaction type.
/// While most fields in this struct are optional, they are not necessarily
/// optional for the type of transaction they apply to.
public struct CodableTransaction {
    /// internal acccess only. The transaction envelope object itself that contains all the transaction data
    /// and type specific implementation
    internal var envelope: AbstractEnvelope

    /// storage container for additional metadata returned by the node
    /// when a transaction is decoded form a JSON stream
    public var meta: TransactionMetadata?

    // MARK: - Properties that always sends to a Node

    /// the address of the sender of the transaction recovered from the signature
    public var sender: EthereumAddress? {
        guard let publicKey = recoverPublicKey() else { return nil }
        return Utilities.publicToAddress(publicKey)
    }

    public var from: EthereumAddress?

    /// the destination, or contract, address for the transaction
    public var to: EthereumAddress {
        get { envelope.to }
        set { envelope.to = newValue }
    }

    /// signifies the transaction type that this payload is for
    /// indicates what fields should be populated.
    /// this should always be set to give an idea of what other fields to expect
    public var type: TransactionType { envelope.type }

    /// the chainId that transaction is targeted for
    /// should be set for all types, except some Legacy transactions (Pre EIP-155)
    /// will not have this set
    public var chainID: BigUInt? {
        get { envelope.chainID }
        set { envelope.chainID = newValue }
    }

    /// the native value of the transaction
    public var value: BigUInt {
        get { envelope.value }
        set { envelope.value = newValue }
    }

    // MARK: - Ruins signing and decoding tests if tied to envelop
    /// any additional data for the transaction
    public var data: Data

    // MARK: - Properties transaction type related either sends to a node if exist

    /// the nonce for the transaction
    public var nonce: BigUInt {
        get { envelope.nonce }
        set { envelope.nonce = newValue }
    }

    /// the max number of gas units allowed to process this transaction
    public var gasLimit: BigUInt {
        get { envelope.gasLimit }
        set { return envelope.gasLimit = newValue }
    }

    /// the price per gas unit for the tranaction (Legacy and EIP-2930 only)
    public var gasPrice: BigUInt? {
        get { envelope.gasPrice }
        set { return envelope.gasPrice = newValue }
    }

    /// the max base fee per gas unit (EIP-1559 only)
    /// this value must be >= baseFee + maxPriorityFeePerGas
    public var maxFeePerGas: BigUInt? {
        get { envelope.maxFeePerGas }
        set { return envelope.maxFeePerGas = newValue }
    }

    /// the maximum tip to pay the miner (EIP-1559 only)
    public var maxPriorityFeePerGas: BigUInt? {
        get { envelope.maxPriorityFeePerGas }
        set { return envelope.maxPriorityFeePerGas = newValue }
    }

    public var callOnBlock: BlockNumber?

    /// access list for contract execution (EIP-2930 and EIP-1559 only)
    public var accessList: [AccessListEntry]?

    // MARK: - Properties to contract encode/sign data only

    // signature data is read-only
    /// signature v component (read only)
    public var v: BigUInt { envelope.v }
    /// signature r component (read only)
    public var r: BigUInt { envelope.r }
    /// signature s component (read only)
    public var s: BigUInt { envelope.s }

    /// the transaction hash
    public var hash: Data? {
        guard let encoded: Data = envelope.encode(for: .transaction) else { return nil }
        let hash = encoded.sha3(.keccak256)
        return hash
    }

    private init() { preconditionFailure("Memberwise not supported") } // disable the memberwise initializer

    /// - Returns: a hash of the transaction suitable for signing
    public func hashForSignature() -> Data? {
        guard let encoded = envelope.encode(for: .signature) else { return nil }
        let hash = encoded.sha3(.keccak256)
        return hash
    }

    /// - Returns: the public key decoded from the signature data
    public func recoverPublicKey() -> Data? {
        guard let sigData = envelope.getUnmarshalledSignatureData() else { return nil }
        guard let vData = BigUInt(sigData.v).serialize().setLengthLeft(1) else { return nil }
        let rData = sigData.r
        let sData = sigData.s

        guard let signatureData = SECP256K1.marshalSignature(v: vData, r: rData, s: sData) else { return nil }
        guard let hash = hashForSignature() else { return nil }

        guard let publicKey = SECP256K1.recoverPublicKey(hash: hash, signature: signatureData) else { return nil }
        return publicKey
    }

    /// Signs the transaction
    ///
    /// This method signs transaction iteself and not related to contract call data signing.
    /// - Parameters:
    ///   - privateKey: the private key to use for signing
    ///   - useExtraEntropy: boolean whether to use extra entropy when signing (default false)
    public mutating func sign(privateKey: Data, useExtraEntropy: Bool = false) throws {
        for _ in 0 ..< 1024 {
            let result = attemptSignature(privateKey: privateKey, useExtraEntropy: useExtraEntropy)
            if result { return }
        }
        throw AbstractKeystoreError.invalidAccountError
    }

    // actual signing algorithm implementation

    private mutating func attemptSignature(privateKey: Data, useExtraEntropy: Bool = false) -> Bool {
        guard let hash = hashForSignature() else { return false }
        let signature = SECP256K1.signForRecovery(hash: hash, privateKey: privateKey, useExtraEntropy: useExtraEntropy)
        guard let serializedSignature = signature.serializedSignature else { return false }
        guard let unmarshalledSignature = SECP256K1.unmarshalSignature(signatureData: serializedSignature) else { return false }
        guard let originalPublicKey = SECP256K1.privateToPublic(privateKey: privateKey) else { return false }
        envelope.setUnmarshalledSignatureData(unmarshalledSignature)
        let recoveredPublicKey = recoverPublicKey()
        if !(originalPublicKey.constantTimeComparisonTo(recoveredPublicKey)) { return false }
        return true
    }

    /// clears the signature data
    public mutating func unsign() { envelope.clearSignatureData() }

    /// Create a new CodableTransaction from a raw stream of bytes from the blockchain
    public init?(rawValue: Data) {
        guard let env = EnvelopeFactory.createEnvelope(rawValue: rawValue) else { return nil }
        envelope = env
        // FIXME: This is duplication and should be fixed.
        data = Data()
    }

    /// - Returns: a raw bytestream of the transaction, encoded according to the transactionType
    public func encode(for type: EncodeType = .transaction) -> Data? { envelope.encode(for: type) }

    public static var emptyTransaction = CodableTransaction(to: EthereumAddress.contractDeploymentAddress())
}

extension CodableTransaction: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case from
        case to
        case nonce
        case chainID
        case value
        case data
        case gasLimit = "gas"
        case gasPrice
        case maxFeePerGas
        case maxPriorityFeePerGas
        case accessList
    }

    /// initializer required to support the Decodable protocol
    /// - Parameter decoder: the decoder stream for the input data
    public init(from decoder: Decoder) throws {
        guard let env = try EnvelopeFactory.createEnvelope(from: decoder) else { throw Web3Error.dataError }
        envelope = env
        // FIXME: This is duplication and should be fixed.
        data = Data()

        // capture any metadata that might be present
        meta = try TransactionMetadata(from: decoder)
    }

    public func encode(to encoder: Encoder) throws {
        // FIXME: There's a huge mess here, please take a look here at code review if any.
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nonce.hexString, forKey: .nonce)
        try container.encode(data.toHexString().add0x, forKey: .data)
        try container.encode(value.hexString, forKey: .value)

        // Encoding only fields with value.
        // TODO: Rewrite me somehow better.
        if type != .legacy {
            try container.encode(type.rawValue.hexString, forKey: .type)
            if let chainID = chainID, !chainID.isZero {
                try container.encode(chainID.hexString, forKey: .chainID)
            }
        }
        if let accessList = accessList, !accessList.isEmpty {
            try container.encode(accessList, forKey: .accessList)
        }

        if !gasLimit.isZero {
            try container.encode(gasLimit.hexString, forKey: .gasLimit)
        }

        if let gasPrice = gasPrice, !gasPrice.isZero {
            try container.encode(gasPrice.hexString, forKey: .gasPrice)
        }

        if let maxFeePerGas = maxFeePerGas, !maxFeePerGas.isZero {
            try container.encode(maxFeePerGas.hexString, forKey: .maxFeePerGas)
        }

        if let maxPriorityFeePerGas = maxPriorityFeePerGas, !maxPriorityFeePerGas.isZero {
            try container.encode(maxPriorityFeePerGas.hexString, forKey: .maxPriorityFeePerGas)
        }

        // Don't encode empty address
        if !to.address.elementsEqual("0x") {
            try container.encode(to, forKey: .to)
        }

        if let from = from {
            try container.encode(from, forKey: .from)
        }
    }

}

extension CodableTransaction: CustomStringConvertible {
    /// required by CustomString convertable
    /// returns a string description for the transaction and its data
    public var description: String {
        var toReturn = ""
        toReturn += "Transaction" + "\n"
        toReturn += String(describing: envelope)
        toReturn += "from: " + String(describing: sender?.address) + "\n"
        toReturn += "hash: " + String(describing: hash?.toHexString().add0x) + "\n"
        return toReturn
    }
}

public extension CodableTransaction {
    // the kitchen sink init: can produce a transaction of any type
    /// Universal initializer to create a new CodableTransaction object
    /// - Parameters:
    ///   - type: TransactionType enum for selecting the type of transaction to create (default is .legacy)
    ///   - to: EthereumAddress of the destination for this transaction (required)
    ///   - nonce: nonce for this transaction (default 0)
    ///   - chainID: chainId the transaction belongs to (default: type specific)
    ///   - value: Native value for the transaction (default 0)
    ///   - data: Payload data for the transaction (required)
    ///   - v: signature v parameter (default 1) - will get set properly once signed
    ///   - r: signature r parameter (default 0) - will get set properly once signed
    ///   - s: signature s parameter (default 0) - will get set properly once signed
    ///   - parameters: EthereumParameters object containing additional parametrs for the transaction like gas
    init(
        type: TransactionType? = nil,
        to: EthereumAddress,
        nonce: BigUInt = 0,
        chainID: BigUInt = 0,
        value: BigUInt = 0,
        data: Data = Data(),
        gasLimit: BigUInt = 0,
        maxFeePerGas: BigUInt? = nil,
        maxPriorityFeePerGas: BigUInt? = nil,
        gasPrice: BigUInt? = nil,
        accessList: [AccessListEntry]? = nil,
        v: BigUInt = 1,
        r: BigUInt = 0,
        s: BigUInt = 0
    ) {
        // FIXME: This is duplication and should be fixed.
        self.data = data
        self.accessList = accessList
        self.callOnBlock = .latest

        envelope = EnvelopeFactory.createEnvelope(type: type, to: to, nonce: nonce, chainID: chainID, value: value, data: data, gasLimit: gasLimit, maxFeePerGas: maxFeePerGas, maxPriorityFeePerGas: maxPriorityFeePerGas, gasPrice: gasPrice, accessList: accessList, v: v, r: r, s: s)
    }
}

extension CodableTransaction: APIRequestParameterType {}
