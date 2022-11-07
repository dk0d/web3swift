//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt
import Core

// FIXME: Rewrite this to CodableTransaction

public typealias Web3Provider = Web3.Provider

/// A web3 instance bound to provider. All further functionality is provided under web.*. namespaces.
///
public class Web3 {

    public class Provider<API: Web3API> {
        public var api: API
        public lazy var manager: KeystoreManager? = KeystoreManager.main

        /// Raw initializer using a Web3Provider protocol object, dispatch queue and request dispatcher.
        public init(api: API, keystore: AbstractKeystore? = nil) {
            self.api = api
            if let keystore { manager?.add(keystore) }
        }

        /// Keystore manager can be bound to Web3 instance. If some manager is bound all further account related functions, such
        /// as account listing, transaction signing, etc. are done locally using private keys and accounts found in a manager.
        public func addKeystore(_ keystore: any AbstractKeystore) {
            manager?.add(keystore)
        }
    }

    public init() {}

    public typealias SubmissionResultHookFunction = (TransactionSendingResult) -> ()

    public struct SubmissionResultHook {
        public var function: SubmissionResultHookFunction
    }

    public var postSubmissionHooks: [SubmissionResultHook] = [SubmissionResultHook]()

}
