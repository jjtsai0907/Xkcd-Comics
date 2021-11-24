//
//  ComicsVM.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation

class ComicsVM: ObservableObject {
    @Published var num = 0
    @Published var title: String = "Default"
    @Published var img: String = "Default"
    @Published var alt: String = "Default"
   
    
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
    
    
}
