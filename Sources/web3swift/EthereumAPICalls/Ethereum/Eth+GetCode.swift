//
//  Created by Yaroslav Yashin.
//  Copyright © 2022 Yaroslav Yashin. All rights reserved.
//

import Foundation
import Core
import BigInt

extension Web3Provider {
    public func code(for address: EthereumAddress, onBlock: BlockNumber = .latest) async throws -> Hash {
        try await APIRequest.send(apiRequest: .getCode(address.address, onBlock), with: api).result
    }
}
