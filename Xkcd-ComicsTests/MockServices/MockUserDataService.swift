//
//  MockUserDataService.swift
//  Xkcd-ComicsTests
//
//  Created by Jia-Jiuan Tsai on 2022-03-03.
//

import Foundation
@testable import Xkcd_Comics

class MockUserDataService: UserDataProtocol {
    func isSaved(comic: Comic) -> Bool {
        true
    }
    
    func addComicToFavorites(comic: Comic) {
        print("saved")
    }
    
    func favoriteComics() -> [Comic] {
        let mockComic2 = Comic(num: 2, title: "Test2", img: "Test2", alt: "Test2", year: "Test2", month: "Test2")
        let mockComic3 = Comic(num: 3, title: "Test3", img: "Test3", alt: "Test3", year: "Test3", month: "Test3")
        return [mockComic2, mockComic3]
    }
}
