//
//  MockFetchingService.swift
//  Xkcd-ComicsTests
//
//  Created by Jia-Jiuan Tsai on 2022-03-03.
//

import Foundation
@testable import Xkcd_Comics

extension Comic {
    static func makeMock(num: Int = 0) -> Self {
        .init(num: num, title: "Test", img: "Test", alt: "Test", year: "Test", month: "Test")
    }
}

class MockFetchingService: FetchingServiceProtocol {
    var fetchLatestComicResult: Result<Comic, FetchingError>
    var fetchSpecificComicResult: Result<Comic, FetchingError>
    
    private(set) var lastSpecificComicNumber: Int?
    
    init(
        fetchLatestComicResult: Result<Comic, FetchingError> = .success(.makeMock(num: 100)),
        fetchSpecificComicResult: Result<Comic, FetchingError> = .success(.makeMock(num: 200))
    ) {
        self.fetchLatestComicResult = fetchLatestComicResult
        self.fetchSpecificComicResult = fetchSpecificComicResult
    }
    
    func fetchComic(comicType: ComicType, completion: @escaping (Result<Comic, FetchingError>) -> Void) {
        switch comicType {
        case .latestComic:
            completion(fetchLatestComicResult)
        case .specificComic(let number):
            lastSpecificComicNumber = number
            completion(fetchSpecificComicResult)
        }
    }
}
