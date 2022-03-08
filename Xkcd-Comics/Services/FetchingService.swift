//
//  FetchingService.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-02-23.
//

import Foundation

class FetchingService: FetchingServiceProtocol {
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    private let requestFactory: RequestFactory
    
    init(urlSession: URLSession, jsonDecoder: JSONDecoder, requestFactory: RequestFactory) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.requestFactory = requestFactory
    }
    
    func fetchComic(comicType: ComicType, completion: @escaping (Result<Comic, FetchingError>) -> Void) {
        let request = requestFactory.makeComicRequest(comicType: comicType)
        
        let task = urlSession.dataTask(with: .init(request)) { data, _, error in
            guard let data = data, error == nil else { return }
            // Convert data to Comic
            do {
                let model = try self.jsonDecoder.decode(Comic.self, from: data)
                print(model.title)
                completion(.success(model))
            } catch {
                completion(.failure(.decodingError))
                print("ComicsVM, fetching comic failed. Error: \(error)")
            }
        }
        task.resume()
    }
}

enum FetchingError: Error {
    case timeOutFailure
    case internetFailure
    case fetchingError
    case decodingError
}
