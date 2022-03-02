//
//  UserDataService.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-02-25.
//

import Foundation
import os

class UserDataService {
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    private let logger: Logger
    
    init(userDefaults: UserDefaults, jsonEncoder: JSONEncoder, jsonDecoder: JSONDecoder, logger: Logger) {
        self.userDefaults = userDefaults
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
        self.logger = logger
    }

    func addComicToFavorites(comic: Comic) {
        var favoriteComics = favoriteComics()
        favoriteComics.append(comic)
        encodeComicsAndSaveAsFavorites(comics: favoriteComics)
        logger.debug("\(MyLogEmojis.debugLog): \(#fileID) Add a comic to the favorite list")
    }
    
    func favoriteComics() -> [Comic] {
        guard let userDefaultData = userDefaults.data(forKey: UserDefaultsKeys.favoriteComics),
              let favoriteComics = decodeComics(comics: userDefaultData) else {
            logger.debug("the favorite list is empty")
            return []
        }
        
        return favoriteComics
    }
    
    func isSaved(comic: Comic) -> Bool {
        return favoriteComics().contains(comic)
    }
    
    private func encodeComicsAndSaveAsFavorites(comics: [Comic]) {
        do {
            let encodedData = try jsonEncoder.encode(comics)
            self.userDefaults.set(encodedData, forKey: UserDefaultsKeys.favoriteComics)
            print("UserDataService: add to UserDefaults:....")
        } catch {
            logger.error("UserDataService: fail to add to UserDefaults. Error: \(error.localizedDescription)")
        }
    }
    
    private func decodeComics(comics: Data) -> [Comic]? {
        do {
            return try jsonDecoder.decode([Comic].self, from: comics)
        } catch {
            logger.error("UserDataService: fail to get UserDefaults. Error: \(error.localizedDescription)")
            return nil
        }
    }
}

enum UserDefaultsKeys {
    static let favoriteComics = "favoriteComics"
}

enum MyLogEmojis {
    static let debugLog = "🐞 Debug"
    static let infoLog = "ℹ️ Info"
    static let noticeLog = "📝 Notice"
    static let warningLog = "⚠️ Warning"
    static let errorLog = "🚫 Error"
    static let criticalLog = "📛 Critical"
    static let alertLog = "‼️ Alert"
    static let emergencyLog = "❌ Emergency"
}

/*
 Loggnivå (Debug, Info, Error, etc)
 Filnamn
 Funktionsnamn
 Radnummer
 Meddelandet
 */
