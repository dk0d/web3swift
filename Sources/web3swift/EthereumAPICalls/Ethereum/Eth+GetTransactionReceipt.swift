//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import BigInt
import Core

extension Web3Provider {
    public func transactionReceipt(_ txhash: Data) async throws -> TransactionReceipt {
        guard let hexString = String(data: txhash, encoding: .utf8)?.add0x else { throw Web3Error.dataError }
        let requestCall: APIRequest = .getTransactionReceipt(hexString)
        return try await APIRequest.send(apiRequest: requestCall, with: api).result
    }
}
