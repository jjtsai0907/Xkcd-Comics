//
//  RequestFactoryTests.swift
//  Xkcd-ComicsTests
//
//  Created by Jia-Jiuan Tsai on 2022-03-08.
//

import XCTest
@testable import Xkcd_Comics

final class RequestFactoryTests: XCTestCase {
    func test_url_latestComic() {
        let requestFactory = makeSUT()
        let request = requestFactory.makeComicRequest(comicType: .latestComic)
        
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.url, URL(string: "https://www.example.com/info.0.json"))
        XCTAssertTrue(request.headers.isEmpty)
    }
    
    func test_url_specificComic() {
        let requestFactory = makeSUT()
        let request = requestFactory.makeComicRequest(comicType: .specificComic(5))
        
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.url, URL(string: "https://www.example.com/5/info.0.json"))
        XCTAssertTrue(request.headers.isEmpty)
    }
    
    private func makeSUT() -> RequestFactory {
        .init(baseURL: .init(string: Constants.baseURLString)!)
    }
    
    enum Constants {
        static let baseURLString = "https://www.example.com"
    }
}
