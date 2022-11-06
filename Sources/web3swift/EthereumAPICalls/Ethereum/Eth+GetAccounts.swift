//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import BigInt
import Core


extension Web3Provider {
    public func ownedAccounts(wallet: Web3.Web3Wallet) async throws -> [EthereumAddress] {
        guard manager == nil else {
            return try wallet.getAccounts(provider: self)
        }
        return try await APIRequest.send(apiRequest: .getAccounts, with: api).result
    }
}
