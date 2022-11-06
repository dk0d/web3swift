//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import Core


extension Web3Provider {
    public func callTransaction(_ transaction: CodableTransaction) async throws -> Data {
        let request: APIRequest = .call(transaction, transaction.callOnBlock ?? .latest)
        return try await APIRequest.send(apiRequest: request, with: api).result
    }
}
