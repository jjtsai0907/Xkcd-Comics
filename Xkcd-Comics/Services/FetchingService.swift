//
//  FetchingService.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-02-23.
//

import Foundation

class FetchingService {
    func fetchComic(fetchingURL: FetchingURL, completion: @escaping (Result<Comic, FetchingErrors>) -> Void) {
        var urlString = ""
        
        switch fetchingURL {
        case .latestComic:
            urlString = "https://xkcd.com/info.0.json"
        case .specificComic(let num):
            urlString = "https://xkcd.com/\(String(describing: num))/info.0.json"
        }
    
        guard let url = URL(string: urlString) else {
            completion(.failure(.URLcrationFailure))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            // Convert data Comic
            do {
                let model = try JSONDecoder().decode(Comic.self, from: data)
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
    case URLcrationFailure
    case timeOutFailure
    case internetFailure
    case fetchingError
}

/*enum  {
    static let baseURL = "https://xkcd.com/info.0.json"
    static let previouseURL = "https://xkcd.com/5/info.0.json" // TO DO: able to go to previous comic
    //static let nextURL = "https://xkcd.com/\(comic.num + 1)/info.0.json"
}*/
