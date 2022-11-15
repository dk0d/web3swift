//
//  Web3+Resolver.swift
//  
//
//  Created by Jann Driessen on 01.11.22.
//

import Foundation
import BigInt
import Core

public class PolicyResolver {

    public init() {}

    public func resolveAll<API: Web3API>(
        for tx: inout CodableTransaction,
        provider: Web3Provider<API>,
        with policies: Policies = .auto
    ) async throws {
        if tx.from != nil || tx.sender != nil {
            // Nonce should be resolved first - as this might be needed for some
            // tx's gas estimation
            tx.nonce = try await resolveNonce(for: tx, with: policies.noncePolicy, api: provider.api)
        } else {
            throw Web3Error.valueError(desc: "Could not be resolved with both from and sender are nil")
        }

        tx.gasLimit = try await resolveGasEstimate(for: tx, with: policies.gasLimitPolicy, api: provider.api)

        if case .eip1559 = tx.type {
            tx.maxPriorityFeePerGas = await resolveGasPriorityFee(for: policies.maxPriorityFeePerGasPolicy, api: provider.api)
            if let priorityGas = tx.maxPriorityFeePerGas {
                let baseFee = await resolveGasBaseFee(for: policies.maxFeePerGasPolicy, api: provider.api)
                tx.maxFeePerGas = 2 * baseFee + priorityGas
            }
        } else {
            tx.gasPrice = await resolveGasPrice(for: policies.gasPricePolicy, api: provider.api)
        }
    }

    public func resolveGasBaseFee(for policy: ValueResolutionPolicy, api: Web3API) async -> BigUInt {
        let oracle = Oracle()
        switch policy {
        case .automatic:
            return await oracle.baseFeePercentiles(api: api).max() ?? 0
        case .manual(let value):
            return value
        }
    }

    public func resolveGasEstimate(for transaction: CodableTransaction, with policy: ValueResolutionPolicy, api: Web3API) async throws -> BigUInt {
        switch policy {
        case .automatic:
            return try await estimateGas(for: transaction, api: api)
        case .manual(let value):
            return value
        }
    }

    public func resolveGasPrice(for policy: ValueResolutionPolicy, api: Web3API) async -> BigUInt {
        let oracle = Oracle()
        switch policy {
        case .automatic:
            return await oracle.gasPriceLegacyPercentiles(api: api).max() ?? 0
        case .manual(let value):
            return value
        }
    }

    public func resolveGasPriorityFee(for policy: ValueResolutionPolicy, api: Web3API) async -> BigUInt {
        let oracle = Oracle()
        switch policy {
        case .automatic:
            return await oracle.tipFeePercentiles(api: api).max() ?? 0
        case .manual(let value):
            return value
        }
    }

    public func resolveNonce(for tx: CodableTransaction, with policy: NoncePolicy, api: Web3API) async throws -> BigUInt {
        switch policy {
        case .pending, .latest, .earliest:
            guard let address = tx.from ?? tx.sender else { throw Web3Error.valueError() }
            let request: APIRequest = .getTransactionCount(address.address, tx.callOnBlock ?? .latest)
            let response: APIResponse<BigUInt> = try await APIRequest.send(apiRequest: request, with: api)
            return response.result
        case .exact(let value):
            return value
        }
    }
}

// MARK: - Private

extension PolicyResolver {
    private func estimateGas(for transaction: CodableTransaction, api: Web3API) async throws -> BigUInt {
        let request: APIRequest = .estimateGas(transaction, transaction.callOnBlock ?? .latest)
        let response: APIResponse<BigUInt> = try await APIRequest.send(apiRequest: request, with: api)
        return response.result
    }
}
