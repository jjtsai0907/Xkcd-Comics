//
//  ParsingService.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-02-25.
//

import Foundation

class ParsingService {
    func encodingComics(comics: [Comic], completion: @escaping (Result<Data, ParsingErrors>) -> Void) {
        // transform the Comic into a JsonFile, and then save it with UserDefaults
        do {
            let encodedData = try JSONEncoder().encode(comics)
            UserDefaults.standard.set(encodedData, forKey: UserFefaultKey.userDefaultsKey)
            print("ParsingService, saving as favourite")
            completion(.success(encodedData))
        } catch {
            completion(.failure(.parsingFailure(error)))
        }
    }
    
    func decodingComics(jsonData: Data, completion: (Result<[Comic], ParsingErrors>) -> Void) {
        // transform jsonData into a Comic
        do {
            let decodedData = try JSONDecoder().decode([Comic].self, from: jsonData)
            print("Decoding in Service")
            completion(.success(decodedData))
        } catch {
            completion(.failure(.parsingFailure(error)))
        }
    }
    
    func getUserDefaultData() -> Data? {
        guard let userDefaultData = UserDefaults.standard.data(forKey: UserFefaultKey.userDefaultsKey) else {
            return nil
        }
        return userDefaultData
    }
}

enum ParsingErrors: Error {
    case parsingFailure(Error)
}

enum UserFefaultKey {
    static let userDefaultsKey = "saved_comic"
}
