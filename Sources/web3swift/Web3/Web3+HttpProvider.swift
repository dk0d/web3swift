//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt
import Core

/// The default http provider.
public class Web3HttpAPI: Web3API {
    public var url: URL
    public var chain: Chain?
    public var session: URLSession = { () -> URLSession in
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        return urlSession
    }()
    public var headers: [String: String] = [:]
    public private(set) var apiKey: String = ""

    public init?(
        _ httpProviderURL: URL,
        apiKey: String = "",
        chain: Chain? = nil
    ) async {
        self.apiKey = apiKey
        guard httpProviderURL.scheme == "https" else { return nil }
        url = httpProviderURL
        if let chain {
            self.chain = chain
        } else {
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.httpMethod = APIRequest.getNetwork.method
            urlRequest.httpBody = APIRequest.getNetwork.requestEncoded
            do {
                let response: APIResponse<UInt> = try await APIRequest.send(urlRequest: urlRequest, with: session)
                self.chain = Chain.from(response.result)
            } catch {
                return nil
            }
        }
    }
}
