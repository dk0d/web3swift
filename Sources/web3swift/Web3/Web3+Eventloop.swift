//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import Core

extension Web3 {

    public class Eventloop {

        public typealias EventLoopCall = (Web3) async -> Void
        public typealias EventLoopContractCall = (Contract) -> Void

        public struct MonitoredProperty {
            public var name: String
            public var calledFunction: EventLoopCall
        }

        var timer: RepeatingTimer? = nil

        public var monitoredProperties: [MonitoredProperty] = [MonitoredProperty]()
        //  public var monitoredContracts: [MonitoredContract] = [MonitoredContract]()
        public var monitoredUserFunctions: [EventLoopRunnableProtocol] = [EventLoopRunnableProtocol]()

        public init() {}

        // @available(iOS 10.0, *)

        public func start(_ timeInterval: TimeInterval) {
            if timer != nil {
                timer!.suspend()
                timer = nil
            }

            timer = RepeatingTimer(timeInterval: timeInterval)
            timer?.eventHandler = runnable
            timer?.resume()

        }

        public func stop() {
            if timer != nil {
                timer!.suspend()
                timer = nil
            }
        }

        func runnable() {
//            for prop in monitoredProperties {
//
//                let function = prop.calledFunction
//                Task {
////                    await function(self.web3)
//                }
//            }

            for prop in monitoredUserFunctions {
                Task {
                    await prop.functionToRun()
                }
            }
        }
    }

}

// Thank you https://medium.com/@danielgalasko/a-background-repeating-timer-in-swift-412cecfd2ef9

class RepeatingTimer {

    let timeInterval: TimeInterval

    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()

    var eventHandler: (() -> Void)?

    private enum State {
        case suspended
        case resumed
    }

    private var state: State = .suspended

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }

    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
