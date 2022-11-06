//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import BigInt
import Core


extension Web3Provider {
    public func block(by hash: Hash, fullTransactions: Bool = false) async throws -> Block {
        let requestCall: APIRequest = .getBlockByHash(hash, fullTransactions)
        return try await APIRequest.send(apiRequest: requestCall, with: api).result
    }

    public func block(by number: BlockNumber, fullTransactions: Bool = false) async throws -> Block {
        let requestCall: APIRequest = .getBlockByNumber(number, fullTransactions)
        return try await APIRequest.send(apiRequest: requestCall, with: api).result
    }
}
