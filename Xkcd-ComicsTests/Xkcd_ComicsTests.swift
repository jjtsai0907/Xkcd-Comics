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
    
    private func makeSUT() -> ComicsViewModel {
        ComicsViewModel(fetchingService: MockFetchingService(), userDataService: MockUserDataService())
    }
    
    func test_ComicsVM_ifSaved_isFalseInitially() {
        let viewModel = makeSUT()
        XCTAssertFalse(viewModel.isSaved)
    }

    func test_ComicsVM_isSaved_shouldBeTrue() {
        let mockComic3 = Comic(num: 2, title: "Test2", img: "Test2", alt: "Test2", year: "Test2", month: "Test2")

        let viewModel = makeSUT()
        
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
    
    // MARK: Fetching Comics
    
    func test_comicsViewModel_fetchComicCalledOnInit() {
        let viewModel = makeSUT()
        
        let expectation = XCTestExpectation(description: "fetchComic should be called on init")
        viewModel.$comic
            .dropFirst()
            .sink { comic in
                XCTAssertEqual(comic.num, 100)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_comicsViewModel_fetchNextComic_shouldSuccess() {
        let viewModel = makeSUT()
        
        let expectation = XCTestExpectation(description: "should be able to fetch next comic")
        
        viewModel.$comic
            .dropFirst()
            .sink { comic in
                guard comic.num == 200 else { return }
                
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModel.fetchNextComic()
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_comicsViewModel_fetchPreviousComic_shouldSuccess() {
        let viewModel = makeSUT()
        
        let expectation = XCTestExpectation(description: "should be able to fetch previous comic")
        viewModel.$comic
            .dropFirst()
            .sink { comic in
                guard comic.num == 200 else { return }
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModel.fetchPreviousComic()
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_comicsViewModel_fetchSearchedComic_shouldSuccess() {
        let expectedComic = Comic(num: 88, title: "", img: "", alt: "", year: "", month: "")
        
        let mockFetchingService = MockFetchingService(fetchSpecificComicResult: .success(expectedComic))
        let viewModel = ComicsViewModel(
            fetchingService: mockFetchingService,
            userDataService: MockUserDataService()
        )
        
        let expectation = XCTestExpectation(description: "should be able to fetch a searched comic")
        viewModel.$comic
            .dropFirst()
            .sink { comic in
                guard comic.num == expectedComic.num else { return }
                
                XCTAssertEqual(mockFetchingService.lastSpecificComicNumber, 9)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModel.searchComic(searchNum: "9")
        viewModel.searchComic(searchNum: "9")
        
        wait(for: [expectation], timeout: 1.5)
    }
    
    func test_comicViewModel_isShowingExplanation_shouldBeToggled() {
        let viewModel = makeSUT()
        
        let isShowingExplanationInitial = viewModel.isShowingExplanation
        
        let expectation = XCTestExpectation(description: "should be toggled")
        viewModel.$isShowingExplanation
            .dropFirst()
            .sink { isShowingExplanation in
                XCTAssertNotEqual(isShowingExplanation, isShowingExplanationInitial)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModel.toggleExplanationSheet()
        wait(for: [expectation], timeout: 1)
    }

}
