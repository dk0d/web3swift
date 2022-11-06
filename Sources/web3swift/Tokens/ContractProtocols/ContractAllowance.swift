//
// Created by Dan Capecci CTR on 11/6/22.
//

import Foundation
import Core
import BigInt

public protocol ContractAllowance: BaseContract {
    func getAllowance<API: Web3API>(originalOwner: EthereumAddress, delegate: EthereumAddress, provider: Web3Provider<API>) async throws -> BigUInt
    func setAllowance<API: Web3API>(from: EthereumAddress, to: EthereumAddress, newAmount: String, provider: Web3Provider<API>) async throws -> WriteOperation
}

extension ContractAllowance {

    public func getAllowance<API: Web3API>(
        originalOwner: EthereumAddress,
        delegate: EthereumAddress,
        provider: Web3Provider<API>
    ) async throws -> BigUInt {
        let contract = self.contract(with: provider)
        transaction.callOnBlock = .latest
        let result = try await contract
        .createReadOperation("allowance", parameters: [originalOwner, delegate] as [AnyObject], extraData: Data())!
        .callContractMethod(provider: provider)
        guard let res = result["0"] as? BigUInt else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
        return res
    }

    public func setAllowance<API: Web3API>(
        from: EthereumAddress,
        to: EthereumAddress,
        newAmount: String,
        provider: Web3Provider<API>
    ) async throws -> WriteOperation {
        let contract = self.contract(with: provider)
        transaction.from = from
        transaction.to = address
        transaction.callOnBlock = .latest

        // get the decimals manually
        let callResult = try await contract
        .createReadOperation("decimals")!
        .callContractMethod(provider: provider)
        var decimals = BigUInt(0)
        guard let dec = callResult["0"], let decTyped = dec as? BigUInt else {
            throw Web3Error.inputError(desc: "Contract may be not \(abi.name) compatible, can not get decimals")
        }
        decimals = decTyped

        let intDecimals = Int(decimals)
        guard let value = Utilities.parseToBigUInt(newAmount, decimals: intDecimals) else {
            throw Web3Error.inputError(desc: "Can not parse inputted amount")
        }

        let tx = contract.createWriteOperation("setAllowance", parameters: [to, value] as [AnyObject])!
        return tx
    }
}
