//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt
import Core

extension Web3.Provider {
    struct TxPool {
        public func txPoolStatus(api: API) async throws -> TxPoolStatus {
            let response: APIResponse<TxPoolStatus> = try await APIRequest.send(apiRequest: .getTxPoolStatus, with: api)
            return response.result
        }

        public func txPoolContent(api: API) async throws -> TxPoolContent {
            let response: APIResponse<TxPoolContent> = try await APIRequest.send(apiRequest: .getTxPoolContent, with: api)
            return response.result
        }
    }
}
