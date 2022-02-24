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
    
    init() {
        fetchComic()
    }
    
    func fetchComic() {
        guard let url = URL(string: "https://xkcd.com/info.0.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            // Convert data to Model
            do {
                let model = try JSONDecoder().decode(Comic.self, from: data)
                print(model.title)
                DispatchQueue.main.async {
                    self.comic = model
                    self.checkIfSaved(comic: model)
                }
            } catch {
                print("ComicsVM, fetching comic failed. Error: \(error)")
            }
        }
        task.resume()
    }
    
    func fetchPreviousComic() {
        guard let url = URL(string: "https://xkcd.com/\(comic.num - 1)/info.0.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            // Convert data to Model
            do {
                let model = try JSONDecoder().decode(Comic.self, from: data)
                print(model.title)
                DispatchQueue.main.async {
                    self.comic = model
                    self.checkIfSaved(comic: model)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isShowingPreviousComicAlert = true
                }
                print("ComicsVM, fetching previous comic failed. Error: \(error)")
            }
        }
        task.resume()
    }
    
    func fetchNextComic() {
        guard let url = URL(string: "https://xkcd.com/\( comic.num + 1)/info.0.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            // Convert data to Model
            do {
                let model = try JSONDecoder().decode(Comic.self, from: data)
                print(model.title)
                DispatchQueue.main.async {
                    self.comic = model
                    self.checkIfSaved(comic: model)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isShowingNextComicAlert = true
                }
                print("ComicsVM, fetching next comic failed. Error: \(error)")
            }
        }
        task.resume()
    }
    
    func toggleDescription() {
        isShowingExplanation.toggle()
    }
    
    func toggleInfo() {
        isShowingInfo.toggle()
    }
    
    func searchComic(searchNum: String) {
        if isShowingSearch {
            // search function
            guard let url = URL(string: "https://xkcd.com/\(searchNum)/info.0.json") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                // Convert data to Model
                do {
                    let model = try JSONDecoder().decode(Comic.self, from: data)
                    print(model.title)
                    DispatchQueue.main.async {
                        self.comic = model
                        self.isShowingSearch = false
                        self.checkIfSaved(comic: model)
                    }
                } catch {
                    print("ComicsVM, searching next comic failed. Error: \(error)")
                }
            }
            task.resume()
        } else {
            isShowingSearch = true
        }
    }
    
    func saveAsFavourite(comic: Comic) {
        if comics.contains(comic) {
            return
        } else {
            // transform the ComicObject into a JsonFile, and then save it with UserDefaults
            comics.append(comic)
            if let encodedData = try? JSONEncoder().encode(comics) {
                UserDefaults.standard.set(encodedData, forKey: Constants.userDefaultsKey)
                print("ComicVM, saving as favourite")
                self.isSaved = true
            }
        }
    }
    
    func getFavouriteComics() {
        // get the JsonFile first and then transform it into a ComicObject
        guard let data = UserDefaults.standard.data(forKey: Constants.userDefaultsKey) else { return }
        guard let favouriteComicsList = try? JSONDecoder().decode([Comic].self, from: data) else { return }
        
        for comic in favouriteComicsList {
            print("ComicVM, getting favourite comics: \(comic.title)")
        }
    }
    
    func checkIfSaved(comic: Comic) {
        if comics.contains(comic) {
            isSaved = true
        } else {
            isSaved = false
        }
    }
    
    private enum Constants {
        static let userDefaultsKey = "saved_comic"
    }
}
