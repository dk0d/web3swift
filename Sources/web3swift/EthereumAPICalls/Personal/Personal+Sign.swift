//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import BigInt
import Core
import Foundation

public extension Web3.Personal {
    func signPersonal<API: Web3API>(provider: Web3Provider<API>, message: Data, from: EthereumAddress, password: String) async throws -> Data {
        guard let attachedKeystoreManager = provider.manager else {
            let hexData = message.toHexString().add0x
            let request: APIRequest = .personalSign(from.address.lowercased(), hexData)
            let response: APIResponse<Data> = try await APIRequest.send(apiRequest: request, with: provider.api)
            return response.result
        }
        guard let signature = try Web3Signer.signPersonalMessage(message, keystore: attachedKeystoreManager, account: from, password: password) else {
            throw Web3Error.inputError(desc: "Failed to locally sign a message")
        }

        return signature
    }
}
