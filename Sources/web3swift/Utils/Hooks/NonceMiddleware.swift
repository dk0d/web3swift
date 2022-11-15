//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt
import Core

public extension Web3.Utils {
//    fileprivate typealias AssemblyHook = web3.AssemblyHook
//    fileprivate typealias SubmissionResultHook = web3.SubmissionResultHook

    class NonceMiddleware<API: Web3API>: EventLoopRunnableProtocol {
        public var name: String = "Nonce lookup middleware"
        public let queue: DispatchQueue = .init(label: "Nonce middleware queue")
        public var synchronizationPeriod: TimeInterval = 300.0 // 5 minutes
        var lastSyncTime = Date()
        var nonceLookups = [EthereumAddress: BigUInt]()

        weak var provider: Web3Provider<API>?

        public init() {}

        public func functionToRun() async {
            guard let provider = provider else { return }
            let knownKeys = Array(nonceLookups.keys)
            await withTaskGroup(of: BigUInt?.self, returning: Void.self) { group in
                knownKeys.forEach { key in
                    group.addTask {
                        try? await provider.getTransactionCount(for: key, onBlock: .latest)
                    }
                }

                var i = 0
                for await value in group {
                    let key = knownKeys[i]
                    self.nonceLookups[key] = value
                    i = i + 1
                }
            }
        }


        // FIXME: Rewrite this to CodableTransaction
//        func preAssemblyFunction(tx: inout CodableTransaction, contract: EthereumContract) -> (CodableTransaction, EthereumContract, Bool) {
//            guard let from = tx.from else {
//                // do nothing
//                return (tx, contract, true)
//            }
//            guard let knownNonce = self.nonceLookups[from] else {
//                return (tx, contract, true)
//            }
//
//            let newNonce = knownNonce + 1
//
//            self.queue.async {
//                self.nonceLookups[from] = newNonce
//            }
//
//            // FIXME:
//            tx.noncePolicy = .exact(newNonce)
//            return (tx, contract, true)
//        }

//        func postSubmissionFunction(result: TransactionSendingResult) {

//            guard let from = result.transaction.sender else {
//                // do nothing
//                return
//            }
//
//            let newNonce = result.transaction.nonceRe
//
//            if let knownNonce = self.nonceLookups[from] {
//                if knownNonce != newNonce {
//                    self.queue.async {
//                        self.nonceLookups[from] = newNonce
//                    }
//                }
//                return
//            }
//            self.queue.async {
//                self.nonceLookups[from] = newNonce
//            }
//            return
//        }

//        public func attach(_ web3: web3) {
//            self.web3 = web3
//            web3.eventLoop.monitoredUserFunctions.append(self)
//            let preHook = AssemblyHook(function: self.preAssemblyFunction)
//            web3.preAssemblyHooks.append(preHook)
//            let postHook = SubmissionResultHook(function: self.postSubmissionFunction)
//            web3.postSubmissionHooks.append(postHook)
//        }
    }
}
