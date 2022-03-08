//
//  RequestFactory.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-03-08.
//

import Foundation

final class RequestFactory {
    private let urls: URLFactory
    
    init(baseURL: URL) {
        urls = URLFactory(baseURL: baseURL)
    }
    
    func makeComicRequest(comicType: ComicType) -> HTTPRequest {
        .init(
            method: .get,
            url: urls.comic(comicType: comicType),
            headers: [:]
        )
    }
    
    private final class URLFactory {
        private let baseURL: URL
        
        init(baseURL: URL) {
            self.baseURL = baseURL
        }
        
        func comic(comicType: ComicType) -> URL {
            switch comicType {
            case .latestComic:
                return baseURL
                    .appendingPathComponent(PathComponents.comicJSON)
            case .specificComic(let num):
                return baseURL
                    .appendingPathComponent(String(describing: num))
                    .appendingPathComponent(PathComponents.comicJSON)
            }
        }
        
        private enum PathComponents {
            static let comicJSON = "info.0.json"
        }
    }
}
