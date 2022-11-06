//
//  BlockNumber.swift
//  
//
//  Created by Yaroslav Yashin on 11.07.2022.
//

import Foundation
import BigInt

public enum BlockNumber: CustomStringConvertible {
    
    case pending
    /// Latest block of a chain
    case latest
    /// Earliest block of a chain
    case earliest
    /// Exact block number
    case exact(BigUInt)

    /// Block number as a hex string
    public var description: String {
        switch self {
        case .pending:
            return "pending"
        case .latest:
            return "latest"
        case .earliest:
            return "earliest"
        case .exact(let number):
            return String(number, radix: 16).add0x
        }
    }
}

extension BlockNumber: APIRequestParameterType {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension BlockNumber: PolicyResolvable {
    public func resolve(api: Web3API, transaction: CodableTransaction?) async throws -> BigUInt {
        guard let transaction = transaction else { throw Web3Error.valueError }
        switch self {
        case .pending, .latest, .earliest:
            guard let address = transaction.from ?? transaction.sender else { throw Web3Error.valueError }
            let request: APIRequest = .getTransactionCount(address.address, transaction.callOnBlock ?? .latest)
            let response: APIResponse<BigUInt> = try await APIRequest.send(apiRequest: request, with: api)
            return response.result
        case .exact(let value):
            return value
        }
    }
}
