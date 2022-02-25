//
//  FetchingService.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-02-23.
//

import Foundation

class FetchingService {
    let urlSession: URLSession
    let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession, jsonDecoder: JSONDecoder) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func fetchComic(fetchingURL: FetchingURL, completion: @escaping (Result<Comic, FetchingErrors>) -> Void) {
        var urlString = ""
        
        switch fetchingURL {
        case .latestComic:
            urlString = "https://xkcd.com/info.0.json"
        case .specificComic(let num):
            urlString = "https://xkcd.com/\(String(describing: num))/info.0.json"
        }
    
        guard let url = URL(string: urlString) else {
            completion(.failure(.URLCrationFailure))
            return
        }
        
        let task = urlSession.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            // Convert data Comic
            do {
                let model = try self.jsonDecoder.decode(Comic.self, from: data)
                print(model.title)
                completion(.success(model))
            } catch {
                completion(.failure(.fetchingError))
                print("ComicsVM, fetching comic failed. Error: \(error)")
            }
        }
        task.resume()
    }
    
    enum FetchingURL {
        case latestComic
        case specificComic(Int)
    }
}

enum FetchingErrors: Error {
    case URLCrationFailure
    case timeOutFailure
    case internetFailure
    case fetchingError
}
