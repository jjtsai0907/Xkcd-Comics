//
//  UserDataService.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-02-25.
//

import Foundation

class UserDataService {
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    init(userDefaults: UserDefaults, jsonEncoder: JSONEncoder, jsonDecoder: JSONDecoder) {
        self.userDefaults = userDefaults
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }

    func addComicToFavorites(comic: Comic) {
        var favoriteComics = favoriteComics()
        favoriteComics.append(comic)
        encodeComics(comics: favoriteComics)
    }
    
    func favoriteComics() -> [Comic] {
        guard let userDefaultData = userDefaults.data(forKey: UserDefaultsKeys.favoriteComics),
              let favoriteComics = decodeComics(comics: userDefaultData) else {
            print("the list is empty")
            return []
        }
        
        return favoriteComics
    }
    
    func isSaved(comic: Comic) -> Bool {
        return favoriteComics().contains(comic)
    }
    
    private func encodeComics(comics: [Comic]) {
        do {
            let encodedData = try jsonEncoder.encode(comics)
            self.userDefaults.set(encodedData, forKey: UserDefaultsKeys.favoriteComics)
            print("UserDataService: add to UserDefaults:....")
        } catch {
            print("UserDataService: fail to add to UserDefaults. Error: \(error)")
        }
    }
    
    private func decodeComics(comics: Data) -> [Comic]? {
        do {
            return try jsonDecoder.decode([Comic].self, from: comics)
        } catch {
            print("UserDataService: fail to get UserDefaults. Error: \(error)")
            return nil
        }
    }
}

enum UserDefaultsKeys {
    static let favoriteComics = "favoriteComics"
}
