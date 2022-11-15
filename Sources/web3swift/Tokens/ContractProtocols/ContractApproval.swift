//
// Created by Dan Capecci CTR on 11/6/22.
//

import BigInt
import Foundation
import Core

public protocol ContractApproval: BaseContract {
    func approve<API: Web3API>(
        from: EthereumAddress,
        spender: EthereumAddress,
        amount: String,
        provider: Web3Provider<API>) async throws -> WriteOperation
}

extension ContractApproval {
    public func approve<API: Web3API>(
        from: EthereumAddress,
        spender: EthereumAddress,
        amount: String,
        provider: Web3Provider<API>
    ) async throws -> WriteOperation {
        let contract = self.contract(with: provider)
        contract.transaction.from = from
        contract.transaction.to = address
        contract.transaction.callOnBlock = .latest
        // get the decimals manually
        let decimals: BigUInt = try await read(contract: contract, provider: provider, method: "decimals")
        let intDecimals = Int(decimals)
        guard let value = Utilities.parseToBigUInt(amount, decimals: intDecimals) else {
            throw Web3Error.inputError(desc: "Can not parse inputted amount")
        }
        let tx = contract.createWriteOperation("approve", parameters: [spender, value] as [AnyObject])!
        return tx
    }
}
