//
//  ContentView.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @StateObject var comicsVM = ComicsVM()
    
    var body: some View {
        VStack{
            Text(comicsVM.title)
                .padding()
            Text("\(comicsVM.num)")
                .padding()
            Text(comicsVM.alt)
                .padding()
            Text(comicsVM.img)
                .padding()
            
            KFImage(URL(string: comicsVM.img))
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
