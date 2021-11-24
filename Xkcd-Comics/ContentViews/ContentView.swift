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
    @State private var showingInfo = false
    
    
    var body: some View {
        NavigationView{
            VStack{
                
                
                if showingInfo {
                    Text(comicsVM.alt)
                        .font(.title2)
                        
                    
                } else {
                    KFImage(URL(string: comicsVM.img))
                        .resizable()
                        .scaledToFit()
                        .padding()
                        
                }
                
                
                
            }.navigationTitle(comicsVM.title)
            .onTapGesture {
                showingInfo.toggle()
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
