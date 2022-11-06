//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt
import Core

/// Custom Web3 HTTP provider of Infura nodes.
public final class InfuraAPI: Web3HttpAPI {
    public init?(_ chain: Chain, accessToken token: String? = nil) async {
        var requestURLstring = "https://" + chain.name + Constants.infuraHttpScheme
        requestURLstring += token ?? Constants.infuraToken
        let providerURL = URL(string: requestURLstring)
        await super.init(providerURL!, chain: chain)
    }
}
