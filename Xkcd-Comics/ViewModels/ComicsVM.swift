//
//  ComicsVM.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation

class ComicsVM: ObservableObject {
    
    let USER_DEFAULTS_KEY = "saved_comic"
    @Published var comicObject: Comic? = nil
    @Published var comicObjectList: [Comic] = []
    
    @Published var ifSaved = false
    
    // Description
    @Published var showingDescription = false
    @Published var showingInfo = false
    
    // Search
    @Published var showingSearch = false
    @Published var searchValue = ""
    
    init() {
        fetchComics()
    }
    
    func fetchComics() {
        guard let url = URL(string: "https://xkcd.com/100/info.0.json") else { return }
        
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
                print("failed")
            }
            
            
        }
        
        
        task.resume()
    }
    
    func fetchPreviousComic() {
        
        guard let url = URL(string: "https://xkcd.com/\(comicObject!.num - 1)/info.0.json") else { return }
        
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
                print("failed")
            }
            
            
        }
        
        
        task.resume()
    }
    
    
    func fetchNextComic() {
        
        guard let url = URL(string: "https://xkcd.com/\( comicObject!.num + 1)/info.0.json") else { return }
        
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
                print("failed")
            }
            
            
        }
        
        
        task.resume()
    }
    
    
    
    
    func showDescription() {
        showingDescription.toggle()
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
                    print("failed")
                }
                
                
            }
            
            
            task.resume()
        
        } else {
            showingSearch = true
        }
        
        
    }
    
    func saveAsFavourite() {
        
        // transform the ComicObject into a JsonFile, and then save it with UserDefaults
        
        comicObjectList.append(comicObject!)
        if let encodedData = try? JSONEncoder().encode(comicObjectList){
            UserDefaults.standard.set(encodedData, forKey: USER_DEFAULTS_KEY)
            print("saveAsFavourite()")
            self.ifSaved = true
        }
        
    }
    
    
    func getFavouriteComic() {
        
        // get the JsonFile first and then transform it into a ComicObject
        guard let data = UserDefaults.standard.data(forKey: USER_DEFAULTS_KEY) else { return }
        guard let favouriteComicsList = try? JSONDecoder().decode([Comic].self, from: data) else { return }
        
        for i in favouriteComicsList {
            print("favourite comics: \(i.title)")
        }
    }
    
    func checkIfSaved(comic: Comic) {
        
        if comicObjectList.contains(comic) {
         ifSaved = true
        } else {
            ifSaved = false
        }
    }
    
}
