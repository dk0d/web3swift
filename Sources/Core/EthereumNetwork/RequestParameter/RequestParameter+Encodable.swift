//
//  RequestParameter+Encodable.swift
//
//
//  Created by Yaroslav Yashin on 12.07.2022.
//

import Foundation

extension RequestParameter: Encodable {
    /**
     This encoder encodes `RequestParameter` assotiated value ignoring self value

     This is required to encode mixed types array, like

     ```swift
     let someArray: [RequestParameter] = [
        .init(rawValue: 12)!,
        .init(rawValue: "this")!,
        .init(rawValue: 12.2)!,
        .init(rawValue: [12.2, 12.4])!
     ]
     let encoded = try JSONEncoder().encode(someArray)
     print(String(data: encoded, encoding: .utf8)!)
     //> [12,\"this\",12.2,[12.2,12.4]]`
     ```
     */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        /// force casting is not needed

        switch self {
        case .int(let value): try container.encode(value)
        case .intArray(let value): try container.encode(value)
        case .uint(let value): try container.encode(value)
        case .uintArray(let value): try container.encode(value)
        case .double(let value): try container.encode(value)
        case .doubleArray(let value): try container.encode(value)
        case .string(let value): try container.encode(value)
        case .stringArray(let value): try container.encode(value)
        case .bool(let value): try container.encode(value)
        case .boolArray(let value): try container.encode(value)
        case .transaction(let value): try container.encode(value)
        case .eventFilter(let value): try container.encode(value)
        case .dictionary(let value): try container.encode(value)
        }
    }
}
