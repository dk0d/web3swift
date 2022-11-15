//
//  Web3Error.swift
//
//
//  Created by Yaroslav Yashin on 11.07.2022.
//

import Foundation

public enum Web3Error: Error {
    case transactionSerializationError
    case connectionError

    case dataError
    case typeError
    case valueError(desc: String? = nil)
    case serverError(code: Int)
    case clientError(code: Int)

    case walletError
    case inputError(desc: String)
    case nodeError(desc: String)
    case processingError(desc: String)
    case keystoreError(err: AbstractKeystoreError)
    case generalError(err: Error)
    case unknownError

    public var errorDescription: String {
        switch self {
        case .transactionSerializationError:
            return "Transaction Serialization Error"
        case .connectionError:
            return "Connection Error"
        case .dataError:
            return "Data Error"
        case .walletError:
            return "Wallet Error"
        case let .inputError(desc):
            return desc
        case let .nodeError(desc):
            return desc
        case let .processingError(desc):
            return desc
        case let .keystoreError(err):
            return err.localizedDescription
        case let .generalError(err):
            return err.localizedDescription
        case .unknownError:
            return "Unknown Error"
        case .typeError:
            return "Unsupported type"
        case let .serverError(code: code):
            return "Server error: \(code)"
        case let .clientError(code: code):
            return "Client error: \(code)"
        case .valueError:
            return "You're passing value that doesn't supported by this method."
        }
    }
}
