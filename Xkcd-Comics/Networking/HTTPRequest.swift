//
//  HTTPRequest.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-03-08.
//

import Foundation

struct HTTPRequest {
    let method: HTTPMethod
    let url: URL
    let headers: [String: String]
}

extension URLRequest {
    init(_ httpRequest: HTTPRequest) {
        var urlRequest = URLRequest(url: httpRequest.url)
        urlRequest.httpMethod = httpRequest.method.rawValue
        
        for (headerKey, headerValue) in httpRequest.headers {
            urlRequest.setValue(headerValue, forHTTPHeaderField: headerKey)
        }
        
        self = urlRequest
    }
}
