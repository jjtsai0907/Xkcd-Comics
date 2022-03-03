//
//  MockFetchingService.swift
//  Xkcd-ComicsTests
//
//  Created by Jia-Jiuan Tsai on 2022-03-03.
//

import Foundation
@testable import Xkcd_Comics

class MockFetchingService: FetchingServiceProtocol {
    func fetchComic(comicType: ComicType, completion: @escaping (Result<Comic, FetchingError>) -> Void) {
        let mockComic = Comic(num: 100, title: "Test", img: "Test", alt: "Test", year: "Test", month: "Test")
        completion(.success(mockComic))
    }
}
