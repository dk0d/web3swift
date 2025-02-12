//
//  APIRequest+UtilityTypes.swift
//  
//
//  Created by Yaroslav Yashin on 12.07.2022.
//

import Foundation


/// JSON RPC response structure for serialization and deserialization purposes.
public struct APIResponse<Result>: Decodable where Result: APIResultType {
    public var id: Int
    public var jsonrpc = "2.0"
    public var result: Result
}

public enum REST {
    case POST(_ method: String?, _ params: RequestParameters?)
    case GET(_ params: RequestParameters?)

    public static var emptyGet: REST { .GET(nil) }
    public static var emptyPost: REST { .POST(nil, nil) }

    public static func post(method: String? = nil, params: [RequestParameter]) -> REST {
        .POST(method, .array(params))
    }

    public static func post(method: String? = nil, params: [String: RequestParameter]) -> REST {
        .POST(method, .dictionary(params))
    }

    public static func get(params: [RequestParameter]) -> REST {
        .GET(.array(params))
    }

    public static func get(params: [String: RequestParameter]) -> REST {
        .GET(.dictionary(params))
    }

    var name: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }

    var jsonRPCBody: JSONRPCBody {
        switch self {
        case .GET(let params):
            return JSONRPCBody(method: "", params: params ?? .array([]))
        case .POST(let method, let params):
            return JSONRPCBody(method: method ?? "", params: params ?? .array([]))
        }
    }

    public var jsonRPCEncoded: Data {
        // this is safe to force try this here
        // Because request must failed to compile if it not conformable with `Encodable` protocol
        try! APIRequestCoder.standard.encode(jsonRPCBody)
    }
}

public struct JSONRPCBody: Encodable {
    var jsonrpc = "2.0"
    var id = Counter.increment()
    var method: String
    var params: RequestParameters
}

public final class APIRequestCoder {
    public static let standard = APIRequestCoder()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    init(
        keyDecode: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
        dateDecode: JSONDecoder.DateDecodingStrategy = .iso8601,
        keyEncode: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase,
        dateEncode: JSONEncoder.DateEncodingStrategy = .iso8601
    ) {
        decoder.keyDecodingStrategy = keyDecode
        decoder.dateDecodingStrategy = dateDecode
        encoder.keyEncodingStrategy = keyEncode
        encoder.dateEncodingStrategy = dateEncode
    }

    public func encode<T: Encodable>(_ encodable: T) throws -> Data {
        try encoder.encode(encodable)
    }

    public func decode<T: Decodable>(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
