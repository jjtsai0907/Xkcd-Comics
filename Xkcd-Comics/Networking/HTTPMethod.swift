//
//  HTTPMethod.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-03-08.
//

enum HTTPMethod: String, Equatable {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case patch = "PATCH"
}
