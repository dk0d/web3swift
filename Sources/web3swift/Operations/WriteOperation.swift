//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import BigInt
import Core
import Foundation

/// Wrapper for `EthererumTransaction.data` property appropriate encoding.
public class WriteOperation: ReadOperation {


    // FIXME: Rewrite this to CodableTransaction
    public func writeToChain<API: Web3API>(
        provider: Web3Provider<API>,
        policies: Policies = .auto,
        password: String
    ) async throws -> TransactionSendingResult {
        if !resolved { try await resolve(policies: policies, with: provider) }
        if let attachedKeystoreManager = provider.manager {
            do {
                try Web3Signer.signTX(transaction: &transaction,
                    keystore: attachedKeystoreManager,
                    account: transaction.from ?? transaction.sender ?? EthereumAddress.contractDeploymentAddress(),
                    password: password)
            } catch {
                throw Web3Error.inputError(desc: "Failed to locally sign a transaction")
            }
            guard let transactionData = transaction.encode(for: .transaction) else { throw Web3Error.dataError }
            return try await provider.send(raw: transactionData)
        }

        // MARK: Sending Data flow
        return try await provider.send(transaction)
    }

    // FIXME: Rewrite this to CodableTransaction

    func nonce<API: Web3API>(
        provider: Web3Provider<API>,
        for policy: NoncePolicy,
        from: EthereumAddress
    ) async throws -> BigUInt {
        switch policy {
        case .latest:
            return try await provider.getTransactionCount(for: from, onBlock: .latest)
        case .pending:
            return try await provider.getTransactionCount(for: from, onBlock: .pending)
        case .earliest:
            return try await provider.getTransactionCount(for: from, onBlock: .earliest)
        case let .exact(nonce):
            return nonce
        }
    }
}
