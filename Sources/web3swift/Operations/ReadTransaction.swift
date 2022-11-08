//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt
import Core

// FIXME: Rewrite this to CodableTransaction

/// Wrapper for `EthererumTransaction.data` property appropriate encoding.
public class ReadOperation {
    public var transaction: CodableTransaction
    public var contract: EthereumContract
    public var method: String
    public var data: Data? { transaction.data }
    var resolver: PolicyResolver

    // FIXME: Rewrite this to CodableTransaction

    public init(
        transaction: CodableTransaction = CodableTransaction.emptyTransaction,
        contract: EthereumContract,
        method: String = "fallback",
        chain: Chain? = nil
    ) {
        self.transaction = transaction
        self.contract = contract
        self.method = method
        if let chain {
            self.transaction.chainID = chain.chainID
        }
        resolver = PolicyResolver()
    }

    public func callContractMethod<API: Web3API>(provider: Web3Provider<API>) async throws -> [String: Any] {
        try await resolver.resolveAll(for: &transaction, api: provider.api)
        // MARK: Read data from ABI flow

        // FIXME: This should be dropped, and after `execute()` call, just to decode raw data.
        let data: Data = try await provider.callTransaction(transaction)
        if method == "fallback" {
            let resultHex = data.toHexString().add0x
            return ["result": resultHex as Any]
        }
        guard let decodedData = contract.decodeReturnData(method, data: data) else {
            throw Web3Error.processingError(desc: "Can not decode returned parameters")
        }
        return decodedData
    }
}
