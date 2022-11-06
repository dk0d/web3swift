//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import BigInt
import Core
import Foundation

extension Web3 {
    public class Web3Wallet {}
}

public extension Web3.Web3Wallet {
    func getAccounts<API: Web3API>(provider: Web3Provider<API>) throws -> [EthereumAddress] {
        guard let keystoreManager = provider.manager else {
            throw Web3Error.walletError
        }
        guard let ethAddresses = keystoreManager.addresses else {
            throw Web3Error.walletError
        }
        return ethAddresses
    }

    func getCoinbase<API: Web3API>(provider: Web3Provider<API>) throws -> EthereumAddress {
        let addresses = try getAccounts(provider: provider)
        guard addresses.count > 0 else {
            throw Web3Error.walletError
        }
        return addresses[0]
    }

    func signTX(
        transaction: inout CodableTransaction,
        account: EthereumAddress,
        keystore: any AbstractKeystore,
        password: String
    ) throws -> Bool {
        do {
            try Web3Signer.signTX(transaction: &transaction, keystore: keystore, account: account, password: password)
            return true
        } catch {
            if error is AbstractKeystoreError {
                throw Web3Error.keystoreError(err: error as! AbstractKeystoreError)
            }
            throw Web3Error.generalError(err: error)
        }
    }

    func signPersonalMessage(
        _ personalMessage: String,
        keystore: any AbstractKeystore,
        account: EthereumAddress,
        password: String
    ) throws -> Data {
        guard let data = Data.fromHex(personalMessage) else {
            throw Web3Error.dataError
        }
        return try signPersonalMessage(data, keystore: keystore, account: account, password: password)
    }

    func signPersonalMessage(
        _ personalMessage: Data,
        keystore: any AbstractKeystore,
        account: EthereumAddress,
        password: String
    ) throws -> Data {
        do {
            guard let data = try Web3Signer.signPersonalMessage(personalMessage, keystore: keystore, account: account, password: password) else {
                throw Web3Error.walletError
            }
            return data
        } catch {
            if error is AbstractKeystoreError {
                throw Web3Error.keystoreError(err: error as! AbstractKeystoreError)
            }
            throw Web3Error.generalError(err: error)
        }
    }
}
