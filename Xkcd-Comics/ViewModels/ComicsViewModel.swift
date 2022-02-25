//
//  ComicsVM.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation

class ComicsViewModel: ObservableObject {
    @Published private(set) var comic = Comic(num: 1, title: "Default", img: "Default", alt: "Default", year: "Default", month: "Default")
    @Published private(set) var comics: [Comic] = []
    @Published private(set) var isSaved = false
    @Published var isShowingNextComicAlert = false
    @Published var isShowingPreviousComicAlert = false
    // Explanation
    @Published var isShowingExplanation = false
    @Published private(set) var isShowingInfo = false
    // Search
    @Published private(set) var isShowingSearch = false
    @Published var searchValue = ""
    let fetchingService: FetchingService
    let parsingService: ParsingService
    
    init(fetchingService: FetchingService, parsingService: ParsingService) {
        self.fetchingService = fetchingService
        self.parsingService = parsingService
        fetchComic()
    }
    
    func fetchComic() {
        fetchingService.fetchComic(fetchingURL: .latestComic) { result in
            switch result {
            case .success(let comic):
                DispatchQueue.main.async {
                    self.comic = comic
                    self.checkIfSaved(comic: comic)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchPreviousComic() {
        print("VM fetchPreviousComic: number of current comic: \(comic.num)")
        fetchingService.fetchComic(fetchingURL: .specificComic(comic.num - 1)) { result in
            switch result {
            case .success(let comic):
                DispatchQueue.main.async {
                    self.comic = comic
                    self.checkIfSaved(comic: comic)
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
        fetchingService.fetchComic(fetchingURL: .specificComic(comic.num + 1)) { result in
            switch result {
            case .success(let comic):
                DispatchQueue.main.async {
                    self.comic = comic
                    self.checkIfSaved(comic: comic)
                }
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
        if isShowingSearch {
            // TODO: error warning if the input is not int
            fetchingService.fetchComic(fetchingURL: .specificComic(Int(searchNum) ?? 1)) { result in
                switch result {
                case .success(let comic):
                    DispatchQueue.main.async {
                        self.comic = comic
                        self.isShowingSearch = false
                        self.checkIfSaved(comic: comic)
                    }
                case .failure(let error):
                    print("ComicsVM, searching next comic failed. Error: \(error)")
                }
            }
        } else {
            isShowingSearch = true
        }
    }
    
    func saveAsFavourite(comic: Comic) {
        if comics.contains(comic) {
            return
        } else {
            comics.append(comic)
            parsingService.encodingComics(comics: comics) { result in
                switch result {
                case .success(let encodedData):
                    UserDefaults.standard.set(encodedData, forKey: UserFefaultsKey.userDefaultsKey)
                    print("ComicVM, saving as favourite")
                    self.isSaved = true
                case .failure(let error):
                    print("ComicVM, saving as favourite failed: \(error)")
                }
            }
        }
    }
    
    func getFavouriteComics() {
        // get the JsonFile first and then transform it into a Comic
        guard let jsonData = parsingService.getUserDefaultData() else {
            return
        }
        parsingService.decodingComics(jsonData: jsonData) { result in
            switch result {
            case .success(let comics):
                for comic in comics {
                    print("ComicVM, getting favourite comics: \(comic.title)")
                }
            case .failure(let error):
                print("ComicViewModel, getting FavouriteComics failed: \(error)")
            }
        }
    }
    
    func checkIfSaved(comic: Comic) {
        if comics.contains(comic) {
            isSaved = true
        } else {
            isSaved = false
        }
    }
}
