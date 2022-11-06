//
// Created by Dan Capecci CTR on 11/6/22.
//

import BigInt
import Core
import Foundation

public protocol ContractTransfer: BaseContract {
    func transfer<API: Web3API>(from: EthereumAddress, to: EthereumAddress, amount: String, provider: Web3Provider<API>) async throws -> WriteOperation
    func transferFrom<API: Web3API>(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, amount: String, provider: Web3Provider<API>) async throws -> WriteOperation
}

extension ContractTransfer {
    public func transfer<API: Web3API>(
        from: EthereumAddress,
        to: EthereumAddress,
        amount: String,
        provider: Web3Provider<API>
    ) async throws -> WriteOperation {
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
        let tx = contract.createWriteOperation("transfer", parameters: [to, value] as [AnyObject])!
        return tx
    }

    public func transferFrom<API: Web3API>(from: EthereumAddress, to: EthereumAddress, originalOwner: EthereumAddress, amount: String, provider: Web3Provider<API>) async throws -> WriteOperation {
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

        let tx = contract.createWriteOperation("transferFrom", parameters: [originalOwner, to, value] as [AnyObject])!
        return tx
    }
}

public protocol ContractTransferWithData: BaseContract {
    func transferWithData<API: Web3API>(from: EthereumAddress, to: EthereumAddress, amount: String, data: [UInt8], provider: Web3Provider<API>) async throws -> WriteOperation
}

extension ContractTransferWithData {
    public func transferWithData<API: Web3API>(
        from: EthereumAddress,
        to: EthereumAddress, amount: String,
        data: [UInt8],
        provider: Web3Provider<API>
    ) async throws -> WriteOperation {
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
        let tx = contract.createWriteOperation("transferWithData", parameters: [to, value, data] as [AnyObject])!
        return tx
    }

    public func transferFromWithData<API: Web3API>(
        from: EthereumAddress,
        to: EthereumAddress,
        originalOwner: EthereumAddress,
        amount: String,
        data: [UInt8],
        provider: Web3Provider<API>
    ) async throws -> WriteOperation {
        let contract = self.contract(with: provider)
        transaction.from = from
        transaction.to = self.address
        transaction.callOnBlock = .latest

        // get the decimals manually
        let decimals: BigUInt = try await read(contract: contract, provider: provider, method: "decimals")
        let intDecimals = Int(decimals)
        guard let value = Utilities.parseToBigUInt(amount, decimals: intDecimals) else {
            throw Web3Error.inputError(desc: "Can not parse inputted amount")
        }
        let tx = contract.createWriteOperation("transferFromWithData", parameters: [originalOwner, to, value, data] as [AnyObject])!
        return tx
    }
}
