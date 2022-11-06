//
// Created by Dan Capecci CTR on 11/6/22.
//

import Foundation
import BigInt
import Core

public protocol ContractSupply: BaseContract {
    func totalSupply<API: Web3API>(_ provider: Web3Provider<API>) async throws -> BigUInt
}

extension ContractSupply {
    public func totalSupply<API: Web3API>(_ provider: Web3Provider<API>) async throws -> BigUInt {
        let contract = self.contract(with: provider)
        transaction.callOnBlock = .latest
        let result = try await contract
        .createReadOperation("totalSupply", parameters: [AnyObject](), extraData: Data())!
        .callContractMethod(provider: provider)
        guard let res = result["0"] as? BigUInt else { throw Web3Error.processingError(desc: "Failed to get result of expected type from the Ethereum node") }
        return res
    }
}
