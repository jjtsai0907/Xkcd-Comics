//
//  ComicsVM.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation
import OSLog

class ComicsViewModel: ObservableObject {
    @Published private(set) var comic = Comic(num: 1, title: "Default", img: "Default", alt: "Default", year: "Default", month: "Default")
    @Published private(set) var isSaved = false
    @Published var isShowingNextComicAlert = false
    @Published var isShowingPreviousComicAlert = false
    // Explanation
    @Published var isShowingExplanation = false
    @Published private(set) var isShowingInfo = false
    // Search
    @Published private(set) var isShowingSearch = false
    @Published var searchValue = ""
    private let fetchingService: FetchingServiceProtocol
    private let userDataService: UserDataProtocol
    private let logger = Logger(subsystem: "RRR", category: "HHH")
    
    init(fetchingService: FetchingServiceProtocol,
         userDataService: UserDataProtocol) {
        self.fetchingService = fetchingService
        self.userDataService = userDataService
        fetchComic()
        logger.debug("fkdsjflsjdlfkslkd")
    }
    
    func fetchComic() {
        fetchingService.fetchComic(comicType: .latestComic) { result in
            switch result {
            case .success(let comic):
                DispatchQueue.main.async {
                    self.handleFetchedComic(comic: comic)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchPreviousComic() {
        print("VM fetchPreviousComic: number of current comic: \(comic.num)")
        fetchingService.fetchComic(comicType: .specificComic(comic.num - 1)) { result in
            switch result {
            case .success(let comic):
                DispatchQueue.main.async {
                    self.handleFetchedComic(comic: comic)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isShowingPreviousComicAlert = true
                }
                print("ComicsVM, fetching previous comic failed. Error: \(error)")
            }
        }
    }
    
    func fetchNextComic() {
        fetchingService.fetchComic(comicType: .specificComic(comic.num + 1)) { result in
            switch result {
            case .success(let comic):
                DispatchQueue.main.async {
                    self.handleFetchedComic(comic: comic)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isShowingNextComicAlert = true
                }
                print("ComicsVM, fetching next comic failed. Error: \(error)")
            }
        }
    }
    
    func toggleExplanationSheet() {
        isShowingExplanation.toggle()
    }
    
    func toggleInfo() {
        isShowingInfo.toggle()
    }
    
    func saveAsFavourite() {
        guard !isSaved else {
            print("already saved")
            return
        }
        userDataService.addComicToFavorites(comic: comic)
        isSaved = self.userDataService.isSaved(comic: self.comic)
    }
    
    func getFavoriteComics() {
        let comics = userDataService.favoriteComics()
        for comic in comics {
            print("ComicVM, getting favorite comics: \(comic.title)")
        }
    }
    
    private func handleFetchedComic(comic: Comic) {
        self.comic = comic
        self.isSaved = self.userDataService.isSaved(comic: comic)
    }
    
    // MARK: SearchView
    
    func toggleSearchView() {
        isShowingSearch.toggle()
    }
    
    func searchComic() {
        // TODO: error warning if the input is not int
        fetchingService.fetchComic(comicType: .specificComic(Int(searchValue) ?? 1)) { result in
            switch result {
            case .success(let comic):
                DispatchQueue.main.async {
                    self.handleFetchedComic(comic: comic)
                    self.isShowingSearch = false
                }
            case .failure(let error):
                print("ComicsVM, searching next comic failed. Error: \(error)")
            }
        }
    }
}
