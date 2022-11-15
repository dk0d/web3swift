//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import Core


extension Web3Provider {
    public func send(raw data: Data) async throws -> TransactionSendingResult {
        let hexString = data.toHexString().add0x
        let request: APIRequest = .sendRawTransaction(hexString)
        let response: APIResponse<Hash> = try await APIRequest.send(apiRequest: request, with: api)
        return try TransactionSendingResult(data: data, hash: response.result)
    }
}

public struct TransactionSendingResult {
    public var transaction: CodableTransaction
    public var hash: String
}

extension TransactionSendingResult {
    init(data: Data, hash: Hash) throws {
        guard let transaction = CodableTransaction(rawValue: data) else { throw Web3Error.dataError }
        self.transaction = transaction
        self.hash = hash
    }
}
