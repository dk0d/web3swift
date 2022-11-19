//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt

// FIXME: Make me work or delete

/// Protocol for generic Ethereum event parsing results
public protocol EventParserResultProtocol {
    var eventName: String { get }
    var decodedResult: [String: Any] { get }
    var contractAddress: EthereumAddress { get }
    var transactionReceipt: TransactionReceipt? { get }
    var eventLog: EventLog? { get }
}

public struct EventParserResult: EventParserResultProtocol {
    public var eventName: String
    public var transactionReceipt: TransactionReceipt?
    public var contractAddress: EthereumAddress
    public var decodedResult: [String: Any]
    public var eventLog: EventLog? = nil

    public init(eventName: String, transactionReceipt: TransactionReceipt? = nil, contractAddress: EthereumAddress, decodedResult: [String: Any], eventLog: EventLog? = nil) {
        self.eventName = eventName
        self.transactionReceipt = transactionReceipt
        self.contractAddress = contractAddress
        self.decodedResult = decodedResult
        self.eventLog = eventLog
    }
}


/// Protocol for generic Ethereum event parser
public protocol EventParserProtocol {
    func parseTransaction(_ transaction: CodableTransaction) async throws -> [EventParserResultProtocol]
    func parseTransactionByHash(_ hash: Data) async throws -> [EventParserResultProtocol]
    func parseBlock(_ block: Block) async throws -> [EventParserResultProtocol]
    func parseBlockByNumber(_ blockNumber: BigUInt) async throws -> [EventParserResultProtocol]
    func parseTransactionPromise(_ transaction: CodableTransaction) async throws -> [EventParserResultProtocol]
    func parseTransactionByHashPromise(_ hash: Data) async throws -> [EventParserResultProtocol]
    func parseBlockByNumberPromise(_ blockNumber: BigUInt) async throws -> [EventParserResultProtocol]
    func parseBlockPromise(_ block: Block) async throws -> [EventParserResultProtocol]
}

/// Enum for the most-used Ethereum networks. Network ID is crucial for EIP155 support
///
/// j
///
///


public enum Chain: CaseIterable, Codable {

    case mainnet            // Production
    case ropsten            // Test
    case rinkeby            // Test
    case goerli             // Test
    case dev                // Development
    case classic            // Production
    case mordor             // Test
    case kotti              // Test
    case astor              // Test
    case polygon            // Mainnet
    case mumbai             // Polygon Test
    case custom(chainId: BigUInt, name: String)


    public var id: UInt {
        switch self {
        case .mainnet:
            return 1            // Production
        case .ropsten:
            return 3            // Test
        case .rinkeby:
            return 4            // Test
        case .goerli:
            return 5            // Test
        case .dev:
            return 2018         // Development
        case .classic:
            return 61           // Production
        case .mordor:
            return 63           // Test
        case .kotti:
            return 6            // Test
        case .astor:
            return 212          // Test
        case .polygon:
            return 137          // Mainnet
        case .mumbai:
            return 80001        // Polygon Test
        case .custom(let chainId, _):
            return UInt(chainId)
        }
    }

    public var chainID: BigUInt { BigUInt(id) }

    public static var allCases: [Chain] { [.mainnet, .goerli, .polygon, .mumbai] }
    public static var mainnets: [Chain] { [.polygon, .mainnet] }
    public static var testnets: [Chain] { [.mumbai, .goerli] }

    public init?(_ bigUIntValue: BigUInt?) {
        guard let bi = bigUIntValue,
              let v = UInt(String(describing: bi))
        else { return nil }
        self = Chain.from(v)
    }

    public init(_ intValue: UInt) {
        self = Chain.from(intValue)
    }

    public static func from(_ id: UInt, name: String? = nil) -> Chain {
        switch id {
        case 1:            // Production
            return .mainnet
        case 3:            // Test
            return .ropsten
        case 4:            // Test
            return .rinkeby
        case 5:            // Test
            return .goerli
        case 2018:         // Development
            return .dev
        case 61:           // Production
            return .classic
        case 63:           // Test
            return .mordor
        case 6:            // Test
            return .kotti
        case 212:          // Test
            return .astor
        case 137:          // Mainnet
            return .polygon
        case 80001:        // Polygon Test
            return .mumbai
        default:
            return .custom(chainId: BigUInt(id), name: name ?? "Custom")
        }
    }

    public var name: String {
        switch self {
        case .mainnet:
            return "ethereum"
        case .ropsten:
            return "ropsten"
        case .rinkeby:
            return "rinkeby"
        case .goerli:
            return "goerli"
        case .dev:
            return "dev"
        case .classic:
            return "classic"
        case .mordor:
            return "mordor"
        case .kotti:
            return "kotti"
        case .astor:
            return "astor"
        case .polygon:
            return "polygon"
        case .mumbai:
            return "mumbai"
        case .custom(_, let name):
            return name
        }
    }
}

extension Chain: Equatable {
    public static func ==(lhs: Chain, rhs: Chain) -> Bool {
        lhs.chainID == rhs.chainID && lhs.name == rhs.name
    }
}


public protocol EventLoopRunnableProtocol {
    var name: String { get }
    func functionToRun() async
}
