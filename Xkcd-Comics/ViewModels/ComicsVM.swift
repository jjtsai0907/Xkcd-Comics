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
    
    @Published var num = 0
    @Published var title: String = "Default"
    @Published var img: String = "Default"
    @Published var alt: String = "Default"
    
    // Description
    @Published var showingDescription = false
    
    
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
                    self.num = model.num
                    self.title = model.title
                    self.img = model.img
                    self.alt = model.alt
                }
                
            } catch {
                print("failed")
            }
            
            
        }
        
        
        task.resume()
    }
    
    func fetchPreviousComic() {
        
        guard let url = URL(string: "https://xkcd.com/\(num - 1)/info.0.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            // Convert data to Model
            do {
                let model = try JSONDecoder().decode(Comic.self, from: data)
                print(model.title)
                
                
                DispatchQueue.main.async {
                    self.num = model.num
                    self.title = model.title
                    self.img = model.img
                    self.alt = model.alt
                    self.comicObject = model
                }
                
            } catch {
                print("failed")
            }
            
            
        }
        
        
        task.resume()
    }
    
    
    func fetchNextComic() {
        
        guard let url = URL(string: "https://xkcd.com/\(num + 1)/info.0.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            // Convert data to Model
            do {
                let model = try JSONDecoder().decode(Comic.self, from: data)
                print(model.title)
                
                DispatchQueue.main.async {
                    self.num = model.num
                    self.title = model.title
                    self.img = model.img
                    self.alt = model.alt
                    self.comicObject = model
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
                        self.num = model.num
                        self.title = model.title
                        self.img = model.img
                        self.alt = model.alt
                        self.comicObject = model
                        self.showingSearch = false
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
        if let encodedData = try? JSONEncoder().encode(comicObject){
            UserDefaults.standard.set(encodedData, forKey: USER_DEFAULTS_KEY)
            print("saveAsFavourite()")
        }
        
    }
    
    
    func getFavouriteComic() {
        
        // get the JsonFile first and then transform it into a ComicObject
        guard let data = UserDefaults.standard.data(forKey: USER_DEFAULTS_KEY) else { return }
        guard let savedComic = try? JSONDecoder().decode(Comic.self, from: data) else { return }
        print("getFavouriteComic(): \(savedComic.title)")
    }
    
}
