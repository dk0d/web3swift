//
// Created by Dan Capecci CTR on 11/6/22.
//

import Foundation
import Core
import BigInt

public protocol ContractIssuable: BaseContract {
    func isIssuable<API: Web3API>(_ provider: Web3Provider<API>) async throws -> Bool
    func issue<API: Web3API>(from: EthereumAddress, tokenHolder: EthereumAddress, amount: String, data: [UInt8], provider: Web3Provider<API>) async throws -> WriteOperation
}

extension ContractIssuable {
    public func isIssuable<API: Web3API>(_ provider: Web3Provider<API>) async throws -> Bool {
        let contract = self.contract(with: provider)
        transaction.callOnBlock = .latest
        return try await read(contract: contract, provider: provider, method: "isIssuable")
    }

    public func issue<API: Web3API>(from: EthereumAddress, tokenHolder: EthereumAddress, amount: String, data: [UInt8], provider: Web3Provider<API>) async throws -> WriteOperation {
        let contract = self.contract(with: provider)
        transaction.from = from
        transaction.to = address
        transaction.callOnBlock = .latest

        // get the decimals manually
        let decimals: BigUInt = try await read(contract: contract, provider: provider, method: "decimals")
        let intDecimals = Int(decimals)
        guard let value = Utilities.parseToBigUInt(amount, decimals: intDecimals) else {
            throw Web3Error.inputError(desc: "Can not parse inputted amount")
        }
        let tx = contract.createWriteOperation("issue", parameters: [tokenHolder, value, data] as [AnyObject])!
        return tx
    }
}
