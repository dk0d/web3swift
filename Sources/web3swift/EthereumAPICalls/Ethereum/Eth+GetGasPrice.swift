//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import BigInt
import Core


extension Web3Provider {
    public func gasPrice() async throws -> BigUInt {
        try await APIRequest.send(apiRequest: .gasPrice, with: api).result
    }
}
