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
            do {
                let encodedData = try jsonEncoder.encode([comic])
                self.userDefaults.set(encodedData, forKey: UserFefaultsKey.userDefaultsKey)
                print("UserDataService: add to UserDefaults:....\(comic.title)")
            } catch {
                print("UserDataService: fail to add to UserDefaults)")
            }
            return
        }
        
        do {
            favouriteComics.append(comic)
            let encodedData = try jsonEncoder.encode(favouriteComics)
            self.userDefaults.set(encodedData, forKey: UserFefaultsKey.userDefaultsKey)
            print("UserDataService: add to UserDefaults \(favouriteComics.count)")
        } catch {
            print("UserDataService: fail to add to UserDefaults")
        }
    }
    
    func favoriteComics() -> [Comic]? {
        guard let userDefaultData = userDefaults.data(forKey: UserFefaultsKey.userDefaultsKey) else {
            print("the list is empty")
            return nil
        }
        do {
            let decodedData = try jsonDecoder.decode([Comic].self, from: userDefaultData)
            print("Decoding in Service")
            print("UserDataService: get UserDefaults")
            for comic in decodedData {
                print("ComicVM, getting favourite comics: \(comic.title)")
            }
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
