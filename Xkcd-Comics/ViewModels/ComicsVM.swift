//
//  ComicsVM.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation

class ComicsVM: ObservableObject {
    @Published var title: String = ""
    
    init() {
        fetchComics()
    }
    
    func fetchComics() {
        guard let url = URL(string: "https://xkcd.com/info.0.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            // Convert data to Model
            do {
                let model = try JSONDecoder().decode(Comics.self, from: data)
                print(model.title)
            } catch {
                print("failed")
            }
            
            
        }
        
        
        task.resume()
    }
    
    
}
