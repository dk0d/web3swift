//  web3swift
//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt
import Core


extension Web3Provider {
    public func send(_ transaction: CodableTransaction) async throws -> TransactionSendingResult {
        let request: APIRequest = .sendTransaction(transaction)
        let response: APIResponse<Hash> = try await APIRequest.send(apiRequest: request, with: api)
        return TransactionSendingResult(transaction: transaction, hash: response.result)
    }

    public func signTX(transaction: inout CodableTransaction, account: EthereumAddress, password: String = "") throws -> Bool {
        do {
            guard let keystoreManager = manager else {
                throw Web3Error.walletError
            }
            try Web3Signer.signTX(transaction: &transaction, keystore: keystoreManager, account: account, password: password)
            return true
        } catch {
            if error is AbstractKeystoreError {
                throw Web3Error.keystoreError(err: error as! AbstractKeystoreError)
            }
            throw Web3Error.generalError(err: error)
        }
    }

    public func send(raw transaction: CodableTransaction) async throws -> TransactionSendingResult {
        var trans = transaction
        guard let from = transaction.from, try signTX(transaction: &trans, account: from) else { throw Web3Error.walletError }
        guard let hash = trans.encode(for: .transaction)?.toHexString().add0x else { throw Web3Error.dataError }
        let request: APIRequest = .sendRawTransaction(hash)
        let response: APIResponse<Hash> = try await APIRequest.send(apiRequest: request, with: api)
        return TransactionSendingResult(transaction: transaction, hash: response.result)
    }
}
