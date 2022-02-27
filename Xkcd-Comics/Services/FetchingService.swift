//
//  FetchingService.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-02-23.
//

import Foundation

class FetchingService {
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession, jsonDecoder: JSONDecoder) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func fetchComic(comicType: ComicType, completion: @escaping (Result<Comic, FetchingError>) -> Void) {
        let urlString: String
        
        switch comicType {
        case .latestComic:
            urlString = "https://xkcd.com/info.0.json"
        case .specificComic(let num):
            urlString = "https://xkcd.com/\(String(describing: num))/info.0.json"
        }
    
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlCreationFailure))
            return
        }
        
        let task = urlSession.dataTask(with: url) { data, _, error in
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
    
    enum ComicType {
        case latestComic
        case specificComic(Int)
    }
}

enum FetchingError: Error {
    case urlCreationFailure
    case timeOutFailure
    case internetFailure
    case fetchingError
    case decodingError
}
