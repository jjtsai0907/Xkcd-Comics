//
//  UserDataProtocol.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-03-03.
//

import Foundation

protocol UserDataProtocol {
    func isSaved(comic: Comic) -> Bool
    func addComicToFavorites(comic: Comic)
    func favoriteComics() -> [Comic]
}
