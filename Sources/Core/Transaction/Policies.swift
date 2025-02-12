//
//  Policies.swift
//  
//
//  Created by Jann Driessen on 01.11.22.
//

import Foundation
import BigInt

public typealias NoncePolicy = BlockNumber

/// Policies for resolving values like:
/// - gas required for transaction execution
/// - gas price
/// - maximum fee per gas
/// - maximum priority fee per gas
public enum ValueResolutionPolicy {
    /// What ever value will be resolved is the one to be applied
    case automatic
    /// Specific value to be applied
    case manual(BigUInt)
}

public struct Policies {
    public let noncePolicy: NoncePolicy
    public let gasLimitPolicy: ValueResolutionPolicy
    public let gasPricePolicy: ValueResolutionPolicy
    public let maxFeePerGasPolicy: ValueResolutionPolicy
    public let maxPriorityFeePerGasPolicy: ValueResolutionPolicy

    public init(
        noncePolicy: NoncePolicy = .latest,
        gasLimitPolicy: ValueResolutionPolicy = .automatic,
        gasPricePolicy: ValueResolutionPolicy = .automatic,
        maxFeePerGasPolicy: ValueResolutionPolicy = .automatic,
        maxPriorityFeePerGasPolicy: ValueResolutionPolicy = .automatic) {
        self.noncePolicy = noncePolicy
        self.gasLimitPolicy = gasLimitPolicy
        self.gasPricePolicy = gasPricePolicy
        self.maxFeePerGasPolicy = maxFeePerGasPolicy
        self.maxPriorityFeePerGasPolicy = maxPriorityFeePerGasPolicy
    }

    public static var auto: Policies {
        Policies(
            noncePolicy: .latest,
            gasLimitPolicy: .automatic,
            gasPricePolicy: .automatic,
            maxFeePerGasPolicy: .automatic,
            maxPriorityFeePerGasPolicy: .automatic
        )
    }
}
