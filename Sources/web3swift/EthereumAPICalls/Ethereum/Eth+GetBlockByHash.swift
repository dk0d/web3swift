//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import BigInt
import Core


extension Web3Provider {
    public func block(by hash: Data, fullTransactions: Bool = false) async throws -> Block {
        let requestCall: APIRequest = .getBlockByHash(hash.toHexString().add0x, fullTransactions)
        return try await APIRequest.send(apiRequest: requestCall, with: api).result
    }
}
