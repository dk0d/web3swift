////
////  Web3+ERC1155.swift
////
////  Created by Anton Grigorev on 20/12/2018.
////  Copyright © 2018 The Matter Inc. All rights reserved.
////
//
//import Foundation
//import BigInt
//import Core
//
//
//// Multi Token Standard
//
//// FIXME: Rewrite this to CodableTransaction
//protocol IERC1155: IERC165 {
//    func safeTransferFrom<API: Web3API>(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, id: BigUInt, value: BigUInt, data: [UInt8], provider: Web3Provider<API>) async throws -> WriteOperation
//    func safeBatchTransferFrom<API: Web3API>(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, ids: [BigUInt], values: [BigUInt], data: [UInt8], provider: Web3Provider<API>) async throws -> WriteOperation
//    func balanceOf<API: Web3API>(account: EthereumAddress, id: BigUInt, provider: Web3Provider<API>) async throws -> BigUInt
//    func setApprovalForAll<API: Web3API>(from: EthereumAddress, operator user: EthereumAddress, approved: Bool, scope: Data, provider: Web3Provider<API>) async throws -> WriteOperation
//    func isApprovedForAll<API: Web3API>(owner: EthereumAddress, operator user: EthereumAddress, scope: Data, provider: Web3Provider<API>) async throws -> Bool
//}
//
//protocol IERC1155Metadata {
//    func uri(id: BigUInt) throws -> String
//    func name(id: BigUInt) throws -> String
//}
//
//public class ERC1155: IERC1155 {
//
//    private var _tokenId: BigUInt? = nil
//    private var _hasReadProperties: Bool = false
//
//    public var transaction: CodableTransaction
//    public var address: EthereumAddress
//    public var abi: String
//
//    func contract<API: Web3API>(with provider: Web3Provider<API>) -> Web3.Contract {
//        let contract = provider.contract(abi, at: address, abiVersion: 2)
//        precondition(contract != nil)
//        return contract!
//    }
//
//    public init(
//        address: EthereumAddress,
//        abi: String = Web3.Utils.erc1155ABI,
//        transaction: CodableTransaction = .emptyTransaction
//    ) {
//        self.address = address
//        self.transaction = transaction
//        self.transaction.to = address
//        self.abi = abi
//    }
//
//    public func tokenId<API: Web3API>(provider: Web3Provider<API>) async throws -> BigUInt {
//        try await readProperties(provider: provider)
//        if _tokenId != nil {
//            return _tokenId!
//        }
//        return 0
//    }
//
//    public func readProperties<API: Web3API>(provider: Web3Provider<API>) async throws {
//        if self._hasReadProperties {
//            return
//        }
//        let contract = contract(with: provider)
//        guard contract.contract.address != nil else { return }
//        self.transaction.callOnBlock = .latest
//
//        guard let tokenIdPromise = try await contract
//        .createReadOperation("id", parameters: [] as [AnyObject], extraData: Data())?
//        .callContractMethod(provider: provider)
//        else { return }
//
//        guard let tokenId = tokenIdPromise["0"] as? BigUInt else { return }
//        self._tokenId = tokenId
//
//        self._hasReadProperties = true
//    }
//
//    public func safeTransferFrom<API: Web3API>(
//        from: EthereumAddress,
//        to: EthereumAddress,
//        originalOwner: EthereumAddress,
//        id: BigUInt,
//        value: BigUInt,
//        data: [UInt8],
//        provider: Web3Provider<API>
//    ) throws -> WriteOperation {
//        let contract = self.contract(with: provider)
//        self.transaction.from = from
//        self.transaction.to = self.address
//
//        let tx = contract.createWriteOperation("safeTransferFrom", parameters: [originalOwner, to, id, value, data] as [AnyObject])!
//        return tx
//    }
//
//    public func safeBatchTransferFrom<API: Web3API>(
//        from: EthereumAddress,
//        to: EthereumAddress,
//        originalOwner: EthereumAddress,
//        ids: [BigUInt],
//        values: [BigUInt],
//        data: [UInt8],
//        provider: Web3Provider<API>
//    ) throws -> WriteOperation {
//        let contract = self.contract(with: provider)
//        transaction.from = from
//        transaction.to = self.address
//
//        let tx = contract
//        .createWriteOperation("safeBatchTransferFrom", parameters: [originalOwner, to, ids, values, data] as [AnyObject])!
//        return tx
//    }
//
//    public func balanceOf<API: Web3API>(
//        account: EthereumAddress,
//        id: BigUInt,
//        provider: Web3Provider<API>
//    ) async throws -> BigUInt {
//        let contract = self.contract(with: provider)
//        transaction.callOnBlock = .latest
//        let result = try await contract
//        .createReadOperation("balanceOf", parameters: [account, id] as [AnyObject], extraData: Data())!
//        .callContractMethod(provider: provider)
//
//        /*
//         let result = try await contract
//             .prepareToRead("balanceOf", parameters: [account, id] as [AnyObject], extraData: Data() )!
//             .execute()
//             .decodeData()
//
//         */
//        guard let res = result["0"] as? BigUInt else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func setApprovalForAll<API: Web3API>(
//        from: EthereumAddress,
//        operator user: EthereumAddress,
//        approved: Bool,
//        scope: Data,
//        provider: Web3Provider<API>
//    ) throws -> WriteOperation {
//        let contract = self.contract(with: provider)
//        self.transaction.from = from
//        self.transaction.to = self.address
//
//        let tx = contract.createWriteOperation("setApprovalForAll", parameters: [user, approved, scope] as [AnyObject])!
//        return tx
//    }
//
//    public func isApprovedForAll<API: Web3API>(
//        owner: EthereumAddress,
//        operator user: EthereumAddress,
//        scope: Data,
//        provider: Web3Provider<API>
//    ) async throws -> Bool {
//        let contract = self.contract(with: provider)
//        self.transaction.callOnBlock = .latest
//
//        let result = try await contract
//        .createReadOperation("isApprovedForAll", parameters: [owner, user, scope] as [AnyObject], extraData: Data())!
//        .callContractMethod(provider: provider)
//
//        guard let res = result["0"] as? Bool else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func supportsInterface<API: Web3API>(interfaceID: String, provider: Web3Provider<API>) async throws -> Bool {
//        let contract = contract(with: provider)
//        self.transaction.callOnBlock = .latest
//        self.transaction.gasLimitPolicy = .manual(30000)
//        let result = try await contract
//        .createReadOperation("supportsInterface", parameters: [interfaceID] as [AnyObject], extraData: Data())!
//        .callContractMethod(provider: provider)
//        guard let res = result["0"] as? Bool else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//}
