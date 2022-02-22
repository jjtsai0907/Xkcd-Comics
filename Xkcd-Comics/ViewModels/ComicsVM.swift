//
//  ComicsVM.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation

class ComicsVM: ObservableObject {
    @Published var comicObject: Comic = Comic(num: 1, title: "Default", img: "Default", alt: "Default", year: "Default", month: "Default")
    @Published var comicObjectList: [Comic] = []
    @Published var isSaved = false
    @Published var showingNextComicAlert = false
    @Published var showingPreviousComicAlert = false
    // Explanation
    @Published var showingExplanation = false
    @Published var showingInfo = false
    // Search
    @Published var showingSearch = false
    @Published var searchValue = ""
    
    init() {
        fetchComics()
    }
    
    func fetchComics() {
        guard let url = URL(string: "https://xkcd.com/info.0.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            // Convert data to Model
            do {
                let model = try JSONDecoder().decode(Comic.self, from: data)
                print(model.title)
                DispatchQueue.main.async {
                    self.comicObject = model
                    self.checkIfSaved(comic: model)
                }
            } catch {
                print("ComicsVM, fetching comic failed. Error: \(error)")
            }
        }
        task.resume()
    }
    
    func fetchPreviousComic() {
        guard let url = URL(string: "https://xkcd.com/\(comicObject.num - 1)/info.0.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            // Convert data to Model
            do {
                let model = try JSONDecoder().decode(Comic.self, from: data)
                print(model.title)
                DispatchQueue.main.async {
                    self.comicObject = model
                    self.checkIfSaved(comic: model)
                }
            } catch {
                DispatchQueue.main.async {
                    self.showingPreviousComicAlert = true
                }
                print("ComicsVM, fetching previous comic failed. Error: \(error)")
            }
        }
        task.resume()
    }
    
    func fetchNextComic() {
        guard let url = URL(string: "https://xkcd.com/\( comicObject.num + 1)/info.0.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            // Convert data to Model
            do {
                let model = try JSONDecoder().decode(Comic.self, from: data)
                print(model.title)
                DispatchQueue.main.async {
                    self.comicObject = model
                    self.checkIfSaved(comic: model)
                }
            } catch {
                DispatchQueue.main.async {
                    self.showingNextComicAlert = true
                }
                print("ComicsVM, fetching next comic failed. Error: \(error)")
            }
        }
        task.resume()
    }
    
    func showDescription() {
        showingExplanation.toggle()
    }
    
    func searchComic(searchNum: String) {
        if showingSearch {
            // search function
            guard let url = URL(string: "https://xkcd.com/\(searchNum)/info.0.json") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                // Convert data to Model
                do {
                    let model = try JSONDecoder().decode(Comic.self, from: data)
                    print(model.title)
                    DispatchQueue.main.async {
                        self.comicObject = model
                        self.showingSearch = false
                        self.checkIfSaved(comic: model)
                    }
                } catch {
                    print("ComicsVM, searching next comic failed. Error: \(error)")
                }
            }
            task.resume()
        } else {
            showingSearch = true
        }
    }
    
    func saveAsFavourite(comic: Comic) {
        if comicObjectList.contains(comic) {
            return
        } else {
            // transform the ComicObject into a JsonFile, and then save it with UserDefaults
            comicObjectList.append(comic)
            if let encodedData = try? JSONEncoder().encode(comicObjectList) {
                UserDefaults.standard.set(encodedData, forKey: Constants.userDefaultsKey)
                print("ComicVM, saving as favourite")
                self.isSaved = true
            }
        }
    }
    
    func getFavouriteComic() {
        // get the JsonFile first and then transform it into a ComicObject
        guard let data = UserDefaults.standard.data(forKey: Constants.userDefaultsKey) else { return }
        guard let favouriteComicsList = try? JSONDecoder().decode([Comic].self, from: data) else { return }
        
        for comic in favouriteComicsList {
            print("ComicVM, getting favourite comics: \(comic.title)")
        }
    }
    
    func checkIfSaved(comic: Comic) {
        if comicObjectList.contains(comic) {
            isSaved = true
        } else {
            isSaved = false
        }
    }
    
    private enum Constants {
        static let userDefaultsKey = "saved_comic"
    }
}
