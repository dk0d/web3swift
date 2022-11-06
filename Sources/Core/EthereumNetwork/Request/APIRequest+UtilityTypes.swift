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
    case GET(_ method: String?, _ params: RequestParameters?)

    public static var emptyGet: REST { .GET(nil,nil) }
    public static var emptyPost: REST { .POST(nil, nil) }

    var name: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }

    var request: RequestBody {
        switch self {
        case .GET(let method, let params):
            return RequestBody(method: method ?? "", params: params ?? .array([]))
        case .POST(let method, let params):
            return RequestBody(method: method ?? "", params: params ?? .array([]))
        }
    }

    public var requestEncoded: Data {
        // this is safe to force try this here
        // Because request must failed to compile if it not conformable with `Encodable` protocol
        try! APIRequestCoder.standard.encode(request)
    }
}

public struct RequestBody: Encodable {
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
