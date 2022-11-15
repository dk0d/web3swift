//
// Created by Dan Capecci CTR on 11/6/22.
//

import BigInt
import Foundation
import Core

public enum ContractReadProperties {
    case name(String?)
    case symbol(String?)
    case decimals(Byte?)
    case tokenId(BigUInt?)
}

public protocol BaseContract: AnyObject {
    var address: EthereumAddress { get set }
    var abi: Web3ABI { get }
    var properties: [ContractReadProperties] { get }
    var hasReadProperties: Bool { get set }
    func contract<API: Web3API>(with provider: Web3Provider<API>) -> Web3Contract
    func readProperties<API: Web3API>(provider: Web3Provider<API>) async throws
    func read<T, API: Web3API>(
        contract: Web3Contract,
        provider: Web3Provider<API>,
        method: String,
        parameters: [AnyObject],
        extra data: Data
    ) async throws -> T
}

extension BaseContract {

    public func contract<API: Web3API>(with provider: Web3Provider<API>) -> Web3.Contract {
        let contract = provider.contract(abi.abiString, at: address, abiVersion: 2)
        precondition(contract != nil)
        return contract!
    }

    public func readProperties<API: Web3API>(provider: Web3Provider<API>) async throws {
        guard !hasReadProperties else { return }
        let contract = contract(with: provider)
        guard contract.contract.address != nil else { return }

        var props: [ContractReadProperties] = []
        for prop in properties {
            switch prop {
            case .name:
                let name = try await contract
                .createReadOperation("name")?
                .callContractMethod(provider: provider)["0"] as? String
                props.append(.name(name))
            case .symbol:
                let symbol = try await contract
                .createReadOperation("symbol")?
                .callContractMethod(provider: provider)["0"] as? String
                props.append(.symbol(symbol))
            case .decimals:
                let decimals = try await contract
                .createReadOperation("decimals")?
                .callContractMethod(provider: provider)["0"] as? BigUInt
                let _decimals = decimals != nil ? Byte(decimals!) : nil
                props.append(.decimals(_decimals))
            case .tokenId:
                async let tokenIdPromise = try contract
                .createReadOperation("tokenId", parameters: [AnyObject](), extraData: Data())?
                .callContractMethod(provider: provider)
                guard let tokenIdResult = try await tokenIdPromise else { return }
                guard let tokenId = tokenIdResult["0"] as? BigUInt else { return }
                props.append(.tokenId(tokenId))
            }
        }
        hasReadProperties = true
    }

    public func read<T, API: Web3API>(
        contract: Web3Contract,
        provider: Web3Provider<API>,
        method: String,
        parameters: [AnyObject] = [],
        extra data: Data = Data()
    ) async throws -> T {
        let callResult = try await contract
        .createReadOperation(method, chain: provider.api.chain, parameters: parameters)!
        .callContractMethod(provider: provider)
        guard let tVal = callResult["0"], let result = tVal as? T else {
            throw Web3Error.inputError(desc: "Contract may be not \(abi.name) compatible, \(method) failed")
        }
        return result
    }


    public func parseAmount<API: Web3API>(
        contract: Web3Contract,
        provider: Web3Provider<API>,
        amount: String
    ) async throws -> BigUInt {
        // get the decimals manually
        let decimals: BigUInt = try await read(
            contract: contract,
            provider: provider,
            method: "decimals"
        )
        let intDecimals = Int(decimals)
        guard let value = Utilities.parseToBigUInt(amount, decimals: intDecimals) else {
            throw Web3Error.inputError(desc: "Can not parse inputted amount")
        }
        return value
    }



}
