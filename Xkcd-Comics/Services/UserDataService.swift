//
//  UserDataService.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-02-25.
//

import Foundation

class UserDataService {
    let userDefaults: UserDefaults
    let jsonEncoder: JSONEncoder
    let jsonDecoder: JSONDecoder
    
    init(userDefaults: UserDefaults, jsonEncoder: JSONEncoder, jsonDecoder: JSONDecoder) {
        self.userDefaults = userDefaults
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }

    func addComicToFavorites(comic: Comic) {
        guard var favouriteComics = favoriteComics() else {
            print("addComicToFavorites: the list is empty")
            encodeComics(comics: [comic])
            return
        }
        favouriteComics.append(comic)
        encodeComics(comics: favouriteComics)
    }
    
    func favoriteComics() -> [Comic]? {
        guard let userDefaultData = userDefaults.data(forKey: UserFefaultsKey.userDefaultsKey) else {
            print("the list is empty")
            return nil
        }
        return decodeComics(comics: userDefaultData)
    }
    
    private func encodeComics(comics: [Comic]) {
        do {
            let encodeData = try jsonEncoder.encode(comics)
            self.userDefaults.set(encodeData, forKey: UserFefaultsKey.userDefaultsKey)
            print("UserDataService: add to UserDefaults:....")
        } catch {
            print("UserDataService: fail to add to UserDefaults. Error: \(error)")
        }
    }
    
    private func decodeComics(comics: Data) -> [Comic]? {
        do {
            let decodedData = try jsonDecoder.decode([Comic].self, from: comics)
            return decodedData
        } catch {
            print("UserDataService: fail to get UserDefaults. Error: \(error)")
            return nil
        }
    }
}

enum UserFefaultsKey {
    static let userDefaultsKey = "saved_comic"
}
