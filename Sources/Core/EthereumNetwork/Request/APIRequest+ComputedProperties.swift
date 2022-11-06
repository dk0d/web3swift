//
//  APIRequest+ComputedProperties.swift
//  
//
//  Created by Yaroslav Yashin on 12.07.2022.
//

import Foundation

extension APIRequest {

    public var requestEncoded: Data { rest.requestEncoded }

    public var rest: REST {
        switch self {
        case .gasPrice, .blockNumber, .getNetwork, .getAccounts, .getTxPoolStatus, .getTxPoolContent:
            return .POST(method, .array([RequestParameter]()))

        case .estimateGas(let transactionParameters, let blockNumber):
            return .POST(method, .array(([.transaction(transactionParameters), .string(blockNumber.description)])))

        case let .sendRawTransaction(hash):
            return .POST(method, .array(([.string(hash)])))

        case let .sendTransaction(transactionParameters):
            return .POST(method, .array(([.transaction(transactionParameters)])))

        case .getTransactionByHash(let hash):
            return .POST(method, .array(([.string(hash)])))

        case .getTransactionReceipt(let receipt):
            return .POST(method, .array(([.string(receipt)])))

        case .getLogs(let eventFilterParameters):
            return .POST(method, .array(([.eventFilter(eventFilterParameters)])))

        case .personalSign(let address, let string):
            return .POST(method, .array(([.string(address), .string(string)])))

        case .call(let transactionParameters, let blockNumber):
            return .POST(method, .array(([.transaction(transactionParameters), .string(blockNumber.description)])))

        case .getTransactionCount(let address, let blockNumber):
            return .POST(method, .array(([.string(address), .string(blockNumber.description)])))

        case .getBalance(let address, let blockNumber):
            return .POST(method, .array(([.string(address), .string(blockNumber.description)])))

        case .getStorageAt(let address, let bigUInt, let blockNumber):
            return .POST(method, .array(([.string(address), .string(bigUInt.hexString), .string(blockNumber.description)])))

        case .getCode(let address, let blockNumber):
            return .POST(method, .array(([.string(address), .string(blockNumber.description)])))

        case .getBlockByHash(let hash, let bool):
            return .POST(method, .array(([.string(hash), .bool(bool)])))

        case .getBlockByNumber(let block, let bool):
            return .POST(method, .array(([.string(block.description), .bool(bool)])))

        case .feeHistory(let uInt, let blockNumber, let array):
            return .POST(method, .array(([.string(uInt.hexString), .string(blockNumber.description), .doubleArray(array)])))

        case .createAccount(let string):
            return .POST(method, .array(([.string(string)])))

        case .unlockAccount(let address, let string, let uInt):
            return .POST(method, .array(([.string(address), .string(string), .uint(uInt ?? 0)])))

        case .custom(_, let rest):
            return rest

        }
    }

    public var method: String {
        switch self {
        case .gasPrice: return "eth_gasPrice"
        case .blockNumber: return "eth_blockNumber"
        case .getNetwork: return "net_version"
        case .getAccounts: return "eth_accounts"
        case .sendRawTransaction: return "eth_sendRawTransaction"
        case .sendTransaction: return "eth_sendTransaction"
        case .getTransactionByHash: return "eth_getTransactionByHash"
        case .getTransactionReceipt: return "eth_getTransactionReceipt"
        case .personalSign: return "eth_sign"
        case .getLogs: return "eth_getLogs"
        case .call: return "eth_call"
        case .estimateGas: return "eth_estimateGas"
        case .getTransactionCount: return "eth_getTransactionCount"
        case .getBalance: return "eth_getBalance"
        case .getStorageAt: return "eth_getStorageAt"
        case .getCode: return "eth_getCode"
        case .getBlockByHash: return "eth_getBlockByHash"
        case .getBlockByNumber: return "eth_getBlockByNumber"
        case .feeHistory: return "eth_feeHistory"

        case .unlockAccount: return "personal_unlockAccount"
        case .createAccount: return "personal_createAccount"
        case .getTxPoolStatus: return "txpool_status"
        case .getTxPoolContent: return "txpool_content"
        case .custom(_, let rest):
            switch rest {
            case .POST(let m, _): return m ?? ""
            case .GET(let m, _): return m ?? ""
            }
        }
    }
}
