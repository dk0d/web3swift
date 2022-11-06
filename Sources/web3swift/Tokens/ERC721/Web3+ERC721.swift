////
////  Created by Alex Vlasov.
////  Copyright © 2018 Alex Vlasov. All rights reserved.
////
//
//import Foundation
//import BigInt
//import Core
//
//// Non-Fungible Token Standard
//
//protocol IERC721: IERC165, BaseContract {
//    func getBalance(account: EthereumAddress) async throws -> BigUInt
//    func transfer(from: EthereumAddress, to: EthereumAddress, tokenId: BigUInt) async throws -> WriteOperation
//    func transferFrom(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, tokenId: BigUInt) async throws -> WriteOperation
//    func approve(from: EthereumAddress, approved: EthereumAddress, tokenId: BigUInt) async throws -> WriteOperation
//
//
//    func getOwner(tokenId: BigUInt) async throws -> EthereumAddress
//    func safeTransferFrom(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, tokenId: BigUInt) async throws -> WriteOperation
//    func safeTransferFrom(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, tokenId: BigUInt, data: [UInt8]) async throws -> WriteOperation
//    func setApprovalForAll(from: EthereumAddress, operator user: EthereumAddress, approved: Bool) async throws -> WriteOperation
//    func getApproved(tokenId: BigUInt) async throws -> EthereumAddress
//    func isApprovedForAll(owner: EthereumAddress, operator user: EthereumAddress) async throws -> Bool
//}
//
//protocol IERC721Metadata {
//    func name() async throws -> String
//    func symbol() async throws -> String
//    func tokenURI(tokenId: BigUInt) async throws -> String
//}
//
//protocol IERC721Enumerable {
//    func totalSupply() async throws -> BigUInt
//    func tokenByIndex(index: BigUInt) async throws -> BigUInt
//    func tokenOfOwnerByIndex(owner: EthereumAddress, index: BigUInt) async throws -> BigUInt
//}
//
//// This namespace contains functions to work with ERC721 tokens.
//
//// can be imperatively read and saved
//public class ERC721: IERC721 {
//
//    private var _tokenId: BigUInt? = nil
//    public var transaction: CodableTransaction
//    public var address: EthereumAddress
//    public var abi: String { Web3Utils.erc721ABI }
//    public var hasReadProperties: Bool = false
//
//    public init(address: EthereumAddress, transaction: CodableTransaction = .emptyTransaction) {
//        self.address = address
//        self.transaction = transaction
//    }
//
//    public func tokenId() async throws -> BigUInt {
//        try await self.readProperties()
//        if self._tokenId != nil {
//            return self._tokenId!
//        }
//        return 0
//    }
//
//
//    public func getBalance(account: EthereumAddress) async throws -> BigUInt {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//        let result = try await contract.createReadOperation("balanceOf", parameters: [account] as [AnyObject], extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? BigUInt else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func getOwner(tokenId: BigUInt) async throws -> EthereumAddress {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//        let result = try await contract.createReadOperation("ownerOf", parameters: [tokenId] as [AnyObject], extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? EthereumAddress else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func getApproved(tokenId: BigUInt) async throws -> EthereumAddress {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//        let result = try await contract.createReadOperation("getApproved", parameters: [tokenId] as [AnyObject], extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? EthereumAddress else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func transfer(from: EthereumAddress, to: EthereumAddress, tokenId: BigUInt) throws -> WriteOperation {
//        let contract = self.contract
//        self.transaction.from = from
//        self.transaction.to = self.address
//
//        let tx = contract.createWriteOperation("transfer", parameters: [to, tokenId] as [AnyObject])!
//        return tx
//    }
//
//    public func transferFrom(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, tokenId: BigUInt) throws -> WriteOperation {
//        let contract = self.contract
//        self.transaction.from = from
//        self.transaction.to = self.address
//
//        let tx = contract.createWriteOperation("transferFrom", parameters: [originalOwner, to, tokenId] as [AnyObject])!
//        return tx
//    }
//
//    public func safeTransferFrom(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, tokenId: BigUInt) throws -> WriteOperation {
//        let contract = self.contract
//        self.transaction.from = from
//        self.transaction.to = self.address
//
//        let tx = contract.createWriteOperation("safeTransferFrom", parameters: [originalOwner, to, tokenId] as [AnyObject])!
//        return tx
//    }
//
//    public func safeTransferFrom(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, tokenId: BigUInt, data: [UInt8]) throws -> WriteOperation {
//        let contract = self.contract
//        self.transaction.from = from
//        self.transaction.to = self.address
//
//        let tx = contract.createWriteOperation("safeTransferFrom", parameters: [originalOwner, to, tokenId, data] as [AnyObject])!
//        return tx
//    }
//
//    public func approve(from: EthereumAddress, approved: EthereumAddress, tokenId: BigUInt) throws -> WriteOperation {
//        let contract = self.contract
//        self.transaction.from = from
//        self.transaction.to = self.address
//
//        let tx = contract.createWriteOperation("approve", parameters: [approved, tokenId] as [AnyObject])!
//        return tx
//    }
//
//    public func setApprovalForAll(from: EthereumAddress, operator user: EthereumAddress, approved: Bool) throws -> WriteOperation {
//        let contract = self.contract
//        self.transaction.from = from
//        self.transaction.to = self.address
//
//        let tx = contract.createWriteOperation("setApprovalForAll", parameters: [user, approved] as [AnyObject])!
//        return tx
//    }
//
//    public func isApprovedForAll(owner: EthereumAddress, operator user: EthereumAddress) async throws -> Bool {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//        let result = try await contract.createReadOperation("isApprovedForAll", parameters: [owner, user] as [AnyObject], extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? Bool else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func supportsInterface<API: Web3API>(interfaceID: String, provider: Web3Provider<API>) async throws -> Bool {
//        let contract = self.contract(with: provider)
//        transaction.callOnBlock = .latest
//        transaction.gasLimitPolicy = .manual(30000)
//        let result = try await contract.createReadOperation("supportsInterface", parameters: [interfaceID] as [AnyObject], extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? Bool else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//}
//
//extension ERC721: IERC721Enumerable {
//
//    public func totalSupply() async throws -> BigUInt {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//        let result = try await contract.createReadOperation("totalSupply", parameters: [AnyObject](), extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? BigUInt else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func tokenByIndex(index: BigUInt) async throws -> BigUInt {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//        let result = try await contract.createReadOperation("tokenByIndex", parameters: [index] as [AnyObject], extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? BigUInt else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func tokenOfOwnerByIndex(owner: EthereumAddress, index: BigUInt) async throws -> BigUInt {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//        let result = try await contract.createReadOperation("tokenOfOwnerByIndex", parameters: [owner, index] as [AnyObject], extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? BigUInt else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//}
//
//// FIXME: Rewrite this to CodableTransaction
//
//extension ERC721: IERC721Metadata {
//
//    public func name() async throws -> String {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//        let result = try await contract.createReadOperation("name", parameters: [AnyObject](), extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? String else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func symbol() async throws -> String {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//        let result = try await contract.createReadOperation("symbol", parameters: [AnyObject](), extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? String else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func tokenURI(tokenId: BigUInt) async throws -> String {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//        let result = try await contract.createReadOperation("tokenURI", parameters: [tokenId] as [AnyObject], extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? String else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//}
//
