////
////  Web3+ERC1594.swift
////
////  Created by Anton Grigorev on 19/12/2018.
////  Copyright © 2018 The Matter Inc. All rights reserved.
////
//
//import Foundation
//import BigInt
//import Core
//
//// Core Security Token Standard
//
//protocol IERC1594: IERC20 {
//
//    // Transfers
//    func transferWithData<API: Web3API>(from: EthereumAddress, to: EthereumAddress, amount: String, data: [UInt8], provider: Web3Provider<API>) async throws -> WriteOperation
//    func transferFromWithData<API: Web3API>(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, amount: String, data: [UInt8], provider: Web3Provider<API>) async throws -> WriteOperation
//
//    // Token Issuance
//    func isIssuable() async throws -> Bool
//    func issue(from: EthereumAddress, tokenHolder: EthereumAddress, amount: String, data: [UInt8]) async throws -> WriteOperation
//
//    // Token Redemption
//    func redeem(from: EthereumAddress, amount: String, data: [UInt8]) async throws -> WriteOperation
//    func redeemFrom(from: EthereumAddress, tokenHolder: EthereumAddress, amount: String, data: [UInt8]) async throws -> WriteOperation
//
//    // Transfer Validity
//    func canTransfer(to: EthereumAddress, amount: String, data: [UInt8]) async throws -> ([UInt8], Data)
//    func canTransferFrom(originalOwner: EthereumAddress, to: EthereumAddress, amount: String, data: [UInt8]) async throws -> ([UInt8], Data)
//
//}
//
//// FIXME: Rewrite this to CodableTransaction
//
//public class ERC1594: IERC1594,
//    ContractBalance,
//    ContractAllowance,
//    ContractSupply,
//    ContractIssuable, ContractTransfer, ContractTransferWithData {
//
//    public var transaction: CodableTransaction
//    public var address: EthereumAddress
//    public var abi: Web3ABI { .erc1594ABI }
//    public var hasReadProperties: Bool = false
//    public var properties: [ContractReadProperties] = [
//        .name(nil),
//        .symbol(nil),
//        .decimals(nil)
//    ]
//
//    public init(address: EthereumAddress, transaction: CodableTransaction = .emptyTransaction) {
//        self.address = address
//        self.transaction = transaction
//        self.transaction.to = address
//    }
//
//    // ERC1594
//
//    public func redeem(from: EthereumAddress, amount: String, data: [UInt8]) async throws -> WriteOperation {
//        let contract = self.contract
//
//        self.transaction.from = from
//        self.transaction.to = self.address
//        self.transaction.callOnBlock = .latest
//
//        // get the decimals manually
//        let callResult = try await contract.createReadOperation("decimals")!.callContractMethod()
//        var decimals = BigUInt(0)
//        guard let dec = callResult["0"], let decTyped = dec as? BigUInt else {
//            throw Web3Error.inputError(desc: "Contract may be not ERC20 compatible, can not get decimals")
//        }
//        decimals = decTyped
//
//        let intDecimals = Int(decimals)
//        guard let value = Utilities.parseToBigUInt(amount, decimals: intDecimals) else {
//            throw Web3Error.inputError(desc: "Can not parse inputted amount")
//        }
//
//        let tx = contract.createWriteOperation("redeem", parameters: [value, data] as [AnyObject])!
//        return tx
//    }
//
//    public func redeemFrom(from: EthereumAddress, tokenHolder: EthereumAddress, amount: String, data: [UInt8]) async throws -> WriteOperation {
//        let contract = self.contract
//
//        self.transaction.from = from
//        self.transaction.to = self.address
//        self.transaction.callOnBlock = .latest
//
//        // get the decimals manually
//        let callResult = try await contract.createReadOperation("decimals")!.callContractMethod()
//        var decimals = BigUInt(0)
//        guard let dec = callResult["0"], let decTyped = dec as? BigUInt else {
//            throw Web3Error.inputError(desc: "Contract may be not ERC20 compatible, can not get decimals")
//        }
//        decimals = decTyped
//
//        let intDecimals = Int(decimals)
//        guard let value = Utilities.parseToBigUInt(amount, decimals: intDecimals) else {
//            throw Web3Error.inputError(desc: "Can not parse inputted amount")
//        }
//
//        let tx = contract.createWriteOperation("redeemFrom", parameters: [tokenHolder, value, data] as [AnyObject])!
//        return tx
//    }
//
//    public func canTransfer(to: EthereumAddress, amount: String, data: [UInt8]) async throws -> ([UInt8], Data) {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//
//        // get the decimals manually
//        let callResult = try await contract.createReadOperation("decimals")!.callContractMethod()
//        var decimals = BigUInt(0)
//        guard let dec = callResult["0"], let decTyped = dec as? BigUInt else {
//            throw Web3Error.inputError(desc: "Contract may be not ERC20 compatible, can not get decimals")
//        }
//        decimals = decTyped
//
//        let intDecimals = Int(decimals)
//        guard let value = Utilities.parseToBigUInt(amount, decimals: intDecimals) else {
//            throw Web3Error.inputError(desc: "Can not parse inputted amount")
//        }
//
//        let result = try await contract.createReadOperation("canTransfer", parameters: [to, value, data] as [AnyObject], extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? ([UInt8], Data) else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//
//    public func canTransferFrom(originalOwner: EthereumAddress, to: EthereumAddress, amount: String, data: [UInt8]) async throws -> ([UInt8], Data) {
//        let contract = self.contract
//        self.transaction.callOnBlock = .latest
//
//        // get the decimals manually
//        let callResult = try await contract.createReadOperation("decimals")!.callContractMethod()
//        var decimals = BigUInt(0)
//        guard let dec = callResult["0"], let decTyped = dec as? BigUInt else {
//            throw Web3Error.inputError(desc: "Contract may be not ERC20 compatible, can not get decimals")
//        }
//        decimals = decTyped
//
//        let intDecimals = Int(decimals)
//        guard let value = Utilities.parseToBigUInt(amount, decimals: intDecimals) else {
//            throw Web3Error.inputError(desc: "Can not parse inputted amount")
//        }
//
//        let result = try await contract.createReadOperation("canTransfer", parameters: [originalOwner, to, value, data] as [AnyObject], extraData: Data())!.callContractMethod()
//        guard let res = result["0"] as? ([UInt8], Data) else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
//        return res
//    }
//}
