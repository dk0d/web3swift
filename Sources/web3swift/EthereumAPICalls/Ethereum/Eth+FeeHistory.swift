//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import BigInt
import Core

extension Web3Provider {
    func feeHistory(blockCount: BigUInt, block: BlockNumber, percentiles:[Double]) async throws -> Oracle.FeeHistory {
        let requestCall: APIRequest = .feeHistory(blockCount, block, percentiles)
        return try await APIRequest.send(apiRequest: requestCall, with: api).result
    }
}
