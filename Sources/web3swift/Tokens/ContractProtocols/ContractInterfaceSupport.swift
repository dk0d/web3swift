//
// Created by Dan Capecci CTR on 11/6/22.
//

import Foundation
import Core

// Standard Interface Detection
public protocol ContractInterface {
    func supportsInterface<API: Web3API>(interfaceID: String, provider: Web3Provider<API>) async throws -> Bool
}

extension ContractInterface {}
