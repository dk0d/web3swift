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
    ) async throws -> (value: BigUInt, op: WriteOperation) {
        let contract = self.contract(with: provider)
        contract.transaction.from = from
        contract.transaction.to = address
        contract.transaction.callOnBlock = .latest

        // get the decimals manually
        let value = try await parseAmount(contract: contract, provider: provider, amount: amount)
        let tx = contract.createWriteOperation("transfer", parameters: [to, value] as [AnyObject])!
        return (value, tx)
    }


    public func transfer<API: Web3API>(
        from: EthereumAddress,
        to: EthereumAddress,
        amount: String,
        provider: Web3Provider<API>
    ) async throws -> WriteOperation {
        let contract = self.contract(with: provider)
        contract.transaction.from = from
        contract.transaction.to = address
        contract.transaction.callOnBlock = .latest

        // get the decimals manually
        let value = try await parseAmount(contract: contract, provider: provider, amount: amount)
        let tx = contract.createWriteOperation("transfer", parameters: [to, value] as [AnyObject])!
        return tx
    }

    public func transferFrom<API: Web3API>(
        from: EthereumAddress,
        to: EthereumAddress,
        originalOwner: EthereumAddress,
        amount: String, provider: Web3Provider<API>
    ) async throws -> WriteOperation {
        let contract = self.contract(with: provider)
        contract.transaction.from = from
        contract.transaction.to = address
        contract.transaction.callOnBlock = .latest

        // get the decimals manually
        let value = try await parseAmount(contract: contract, provider: provider, amount: amount)
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
        contract.transaction.from = from
        contract.transaction.to = address
        contract.transaction.callOnBlock = .latest

        // get the decimals manually
        let value = try await parseAmount(contract: contract, provider: provider, amount: amount)
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
        contract.transaction.from = from
        contract.transaction.to = address
        contract.transaction.callOnBlock = .latest

        // get the decimals manually
        let value = try await parseAmount(contract: contract, provider: provider, amount: amount)
        let tx = contract.createWriteOperation("transferFromWithData", parameters: [originalOwner, to, value, data] as [AnyObject])!
        return tx
    }
}
