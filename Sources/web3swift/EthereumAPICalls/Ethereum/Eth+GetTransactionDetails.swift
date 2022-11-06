//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import BigInt
import Core

extension Web3Provider {

    public func transactionDetails(_ txhashString: String) async throws -> TransactionDetails {
        let requestCall: APIRequest = .getTransactionByHash(txhashString)
        return try await APIRequest.send(apiRequest: requestCall, with: api).result
    }

    public func transactionDetails(_ txhash: Data) async throws -> TransactionDetails {
        guard let hexString = String(data: txhash, encoding: .utf8)?.add0x else { throw Web3Error.dataError }
        return try await transactionDetails(hexString)
    }
}
