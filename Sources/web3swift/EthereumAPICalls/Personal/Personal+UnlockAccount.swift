//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import BigInt
import Core
import Foundation

public extension Web3.Personal {
    func unlock<API: Web3API>(provider: Web3Provider<API>, account: EthereumAddress, password: String, seconds: UInt = 300) async throws -> Bool {
        try await unlock(provider: provider, account: account.address, password: password, seconds: seconds)
    }

    func unlock<API: Web3API>(provider: Web3Provider<API>, account: Address, password: String, seconds: UInt = 300) async throws -> Bool {
        guard provider.manager == nil else {
            throw Web3Error.inputError(desc: "Can not unlock a local keystore")
        }

        let requestCall: APIRequest = .unlockAccount(account, password, seconds)
        let response: APIResponse<Bool> = try await APIRequest.send(apiRequest: requestCall, with: provider.api)
        return response.result
    }
}

extension Bool: APIResultType {}
