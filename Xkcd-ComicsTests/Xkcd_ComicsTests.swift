//
//  Xkcd_ComicsTests.swift
//  Xkcd-ComicsTests
//
//  Created by Jia-Jiuan Tsai on 2021-11-26.
//

import XCTest
@testable import Xkcd_Comics

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Testing Structure: Given, When, Then

class XkcdComicsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ComicsVM_ifSaved_shouldBeTrue() {
        // Given
        let comic = Comic(num: 1, title: "Test", img: "Test", alt: "Test", year: "Test", month: "Test")
        // When
        let viewModel = ComicsViewModel()
        viewModel.saveAsFavourite(comic: comic)
        // Then
        XCTAssertTrue(viewModel.ifSaved)
    }
    
    func test_ComicsVM_comicObjectList_shouldBeEmpty() {
        // Given
        // When
        let viewModel = ComicsViewModel()
        // Then
        XCTAssertTrue(viewModel.comics.isEmpty)
    }
    
    func test_ComicsVM_comicObjectList_shouldSaveAsFavourite() {
        // Given
        let comic = Comic(num: 1, title: "Test", img: "Test", alt: "Test", year: "Test", month: "Test")
        let viewModel = ComicsViewModel()
        // When
        viewModel.saveAsFavourite(comic: comic)
        // Then
        XCTAssertEqual(viewModel.comics.count, 1)
    }

}
