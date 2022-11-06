//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation

public class KeystoreManager: AbstractKeystore {
    public var isHDKeystore: Bool { false }
    public var path: String { "main" }

    public var addresses: [EthereumAddress]? {
        var toReturn = [EthereumAddress]()
        for keystore in _keystores {
            guard let key = keystore.addresses?.first else {
                continue
            }
            if key.isValid {
                toReturn.append(key)
            }
        }
        return toReturn
    }

    public func UNSAFE_getPrivateKeyData(password: String, account: EthereumAddress) throws -> Data {
        guard let keystore = keyStore(for: account) else { throw AbstractKeystoreError.invalidAccountError }
        return try keystore.UNSAFE_getPrivateKeyData(password: password, account: account)
    }

    public static var main: KeystoreManager = .init([AbstractKeystore]())

    public static func managerForPath(_ path: String, scanForHDwallets: Bool = false, suffix: String? = nil) -> KeystoreManager? {
        guard let manager = try? KeystoreManager(path, scanForHDwallets: scanForHDwallets, suffix: suffix) else {
            return nil
        }
        return manager
    }

    public func keyStore(for address: EthereumAddress) -> AbstractKeystore? {
        for keystore in _keystores {
            if keystore.contains(address) {
                return keystore as AbstractKeystore?
            }
        }
        return nil
    }

    var _keystores: [AbstractKeystore] = .init()

    public var keystores: [AbstractKeystore] {
        _keystores
    }

    public init(_ keystores: [AbstractKeystore]) { _keystores = keystores }

    private init?(_ path: String, scanForHDwallets: Bool = false, suffix: String? = nil) throws {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        var exists = fileManager.fileExists(atPath: path, isDirectory: &isDir)
        if !exists, !isDir.boolValue {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            exists = fileManager.fileExists(atPath: path, isDirectory: &isDir)
        }
        if !isDir.boolValue {
            return nil
        }
        let allFiles = try fileManager.contentsOfDirectory(atPath: path)
        if suffix != nil {
            for file in allFiles where file.hasSuffix(suffix!) {
                var filePath = path
                if !path.hasSuffix("/") {
                    filePath = path + "/"
                }
                filePath = filePath + file
                guard let content = fileManager.contents(atPath: filePath) else {
                    continue
                }
                if scanForHDwallets {
                    guard let bipkeystore = BIP32Keystore(content) else {
                        continue
                    }
                    _keystores.append(bipkeystore)
                } else {
                    guard let keystore = EthereumKeystoreV3(content) else {
                        continue
                    }
                    _keystores.append(keystore)
                }
            }
        } else {
            for file in allFiles {
                var filePath = path
                if !path.hasSuffix("/") {
                    filePath = path + "/"
                }
                filePath = filePath + file
                guard let content = fileManager.contents(atPath: filePath) else {
                    continue
                }
                if scanForHDwallets {
                    guard let bipkeystore = BIP32Keystore(content) else {
                        continue
                    }
                    _keystores.append(bipkeystore)
                } else {
                    guard let keystore = EthereumKeystoreV3(content) else {
                        continue
                    }
                    _keystores.append(keystore)
                }
            }
        }
    }


    public func add(_ keystore: any AbstractKeystore) {
        _keystores.append(keystore)
    }
}
