//
//  Xkcd_ComicsTests.swift
//  Xkcd-ComicsTests
//
//  Created by Jia-Jiuan Tsai on 2021-11-26.
//

import XCTest
import Combine
@testable import Xkcd_Comics

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Testing Structure: Given, When, Then

class XkcdComicsTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_ComicsVM_ifSaved_isFalseInitially() {
        let viewModel = ComicsViewModel(fetchingService: MockFetchingService(), userDataService: MockUserDataService())
        
        XCTAssertFalse(viewModel.isSaved)
    }

    func test_ComicsVM_isSaved_shouldBeTrue() {
        let mockComic3 = Comic(num: 2, title: "Test2", img: "Test2", alt: "Test2", year: "Test2", month: "Test2")

        let viewModel = ComicsViewModel(fetchingService: MockFetchingService(), userDataService: MockUserDataService())
        
        let expectation = XCTestExpectation(description: "hey")
        viewModel.$isSaved
            .dropFirst()
            .sink { isSaved in
                XCTAssertTrue(isSaved, "isSaved should become true when something has been saved as favorite")
                
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModel.saveAsFavourite(comic: mockComic3)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_comicsViewModel_fetchComicCalledOnInit() {
        let viewModel = ComicsViewModel(fetchingService: MockFetchingService(),
                                        userDataService: MockUserDataService()
        )
        
        let expectation = XCTestExpectation(description: "fetchComic should be called on init")
        viewModel.$comic
            .dropFirst()
            .sink { comic in
                XCTAssertEqual(comic.num, 100)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 5.5)
    }
    
    /*func test_ComicsVM_comicObjectList_shouldBeEmpty() {
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
    }*/

}
