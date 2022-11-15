//
// Created by Dan Capecci CTR on 11/6/22.
//

import BigInt
import Core
import Foundation



public protocol ContractBalance: BaseContract {
    func getBalance<API: Web3API>(account: EthereumAddress, provider: Web3Provider<API>) async throws -> BigUInt
}

extension ContractBalance {
    public func getBalance<API: Web3API>(account: EthereumAddress, provider: Web3Provider<API>) async throws -> BigUInt {
        let contract = self.contract(with: provider)
        contract.transaction.callOnBlock = .latest
        return try await read(
            contract: contract,
            provider: provider,
            method: "balanceOf",
            parameters: [account] as [AnyObject])

    }
}
