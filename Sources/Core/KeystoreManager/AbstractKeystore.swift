//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation

public protocol AbstractKeystore {
    var addresses: [EthereumAddress]? { get }
    var isHDKeystore: Bool { get }
    var path: String { get }

    func UNSAFE_getPrivateKeyData(password: String, account: EthereumAddress) throws -> Data
    func contains(_ account: EthereumAddress) -> Bool
}

public enum AbstractKeystoreError: Error {
    case noEntropyError
    case keyDerivationError
    case aesError
    case invalidAccountError
    case invalidPasswordError
    case encryptionError(String)
}

public extension AbstractKeystore {
    func contains(_ account: EthereumAddress) -> Bool { addresses?.contains(account) ?? false }
}
