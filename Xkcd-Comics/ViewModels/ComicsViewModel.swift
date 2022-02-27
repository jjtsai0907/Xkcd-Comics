//
//  ComicsVM.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation

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
    private let fetchingService: FetchingService
    private let userDataService: UserDataService
    
    init(fetchingService: FetchingService,
         userDataService: UserDataService) {
        self.fetchingService = fetchingService
        self.userDataService = userDataService
        fetchComic()
    }
    
    func fetchComic() {
        fetchingService.fetchComic(comicType: .latestComic) { result in
            switch result {
            case .success(let comic):
                self.handleFetchedComic(comic: comic)
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
                self.handleFetchedComic(comic: comic)
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
                self.handleFetchedComic(comic: comic)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isShowingNextComicAlert = true
                }
                print("ComicsVM, fetching next comic failed. Error: \(error)")
            }
        }
    }
    
    func toggleDescription() {
        isShowingExplanation.toggle()
    }
    
    func toggleInfo() {
        isShowingInfo.toggle()
    }
    
    func searchComic(searchNum: String) {
        guard isShowingSearch else {
            isShowingSearch = true
            return
        }
        // TODO: error warning if the input is not int
        fetchingService.fetchComic(comicType: .specificComic(Int(searchNum) ?? 1)) { result in
            switch result {
            case .success(let comic):
                DispatchQueue.main.async {
                    self.comic = comic
                    self.isSaved = self.isSaved(comic: comic)
                    self.isShowingSearch = false
                }
            case .failure(let error):
                print("ComicsVM, searching next comic failed. Error: \(error)")
            }
        }
    }
    
    func saveAsFavourite(comic: Comic) {
        guard !isSaved else {
            print("already saved")
            return
        }
        DispatchQueue.main.async {
            self.isSaved = self.isSaved(comic: comic)
        }
        userDataService.addComicToFavorites(comic: comic)
    }
    
    func getFavoriteComics() {
        guard let comics = userDataService.favoriteComics() else {
            return
        }
        for comic in comics {
            print("ComicVM, getting favorite comics: \(comic.title)")
        }
    }
    
    private func isSaved(comic: Comic) -> Bool {
        guard let favouriteComics = userDataService.favoriteComics() else {
            return false
        }
        if favouriteComics.contains(comic) {
            return true
        }
        return false
    }
    
    private func handleFetchedComic(comic: Comic) {
        DispatchQueue.main.async {
            self.comic = comic
            self.isSaved = self.isSaved(comic: comic)
        }
    }
}
