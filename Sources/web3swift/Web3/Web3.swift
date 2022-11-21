//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Core
import Foundation

/// An arbitary Web3 object. Is used only to construct provider bound fully functional object by either supplying provider URL
/// or using pre-coded Infura nodes
public extension Web3Provider where API == Web3HttpAPI {
    /// Initialized provider-bound Web3 instance using a provider's URL. Under the hood it performs a synchronous call to get
    /// the Network ID for EIP155 purposes
    static func new(_ providerURL: URL) async throws -> Web3Provider<Web3HttpAPI> {
        // FIXME: Change this hardcoded value to dynamicly fethed from a Node
        guard let api = await Web3HttpAPI(providerURL, chain: .ethereum) else {
            throw Web3Error.inputError(desc: "Wrong provider - should be Web3HttpProvider with endpoint scheme http or https")
        }
        return Web3Provider(api: api)
    }
}

public extension Web3Provider where API == InfuraAPI {

    /// Initialized Web3 instance bound to Infura's mainnet provider.
    static func InfuraMainnetWeb3(accessToken: String? = nil) async -> Web3Provider<API> {
        let infura = await InfuraAPI(Chain.ethereum, accessToken: accessToken)!
        return Web3Provider(api: infura)
    }

    /// Initialized Web3 instance bound to Infura's goerli provider.
    static func InfuraGoerliWeb3(accessToken: String? = nil) async -> Web3Provider<API> {
        let infura = await InfuraAPI(Chain.goerli, accessToken: accessToken)!
        return Web3Provider(api: infura)
    }

    /// Initialized Web3 instance bound to Infura's rinkeby provider.
    @available(*, deprecated, message: "This network support was deprecated by Infura")
    static func InfuraRinkebyWeb3(accessToken: String? = nil) async -> Web3Provider<API> {
        let infura = await InfuraAPI(Chain.rinkeby, accessToken: accessToken)!
        return Web3Provider(api: infura)
    }

    /// Initialized Web3 instance bound to Infura's ropsten provider.
    @available(*, deprecated, message: "This network support was deprecated by Infura")
    static func InfuraRopstenWeb3(accessToken: String? = nil) async -> Web3Provider<API> {
        let infura = await InfuraAPI(Chain.ropsten, accessToken: accessToken)!
        return Web3Provider(api: infura)
    }

    /// Initialized Web3 instance bound to Infura's kovan provider.
//    @available(*, deprecated, message: "This network support was deprecated by Infura")
//    static func InfuraKovanWeb3(accessToken: String? = nil) async -> Web3Provider<API> {
//        let infura = await InfuraAPI(Chain.kovan, accessToken: accessToken)!
//        return Web3Provider(api: infura)
//    }
}
