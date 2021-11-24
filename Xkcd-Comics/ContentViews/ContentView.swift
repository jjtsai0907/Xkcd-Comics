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
                Spacer()
                
                if showingInfo {
                    VStack{
                        Text(comicsVM.alt)
                            .font(.title2)
                        Text("\(comicsVM.num)")
                        
                        HStack{
                            ButtonView(icon: "info.circle", title:"Explanation"){
                                comicsVM.showDescription()
                            }.sheet(isPresented: $comicsVM.showingDescription, content:{ExplanationSheet(num: comicsVM.num)})
                        }
                    }
                    
                    
                } else {
                    KFImage(URL(string: comicsVM.img))
                        .resizable()
                        .scaledToFit()
                        .padding()
                        
                }
                
                Spacer()
                
                HStack{
                    ButtonView(icon: "arrowshape.turn.up.backward", title:"Previous"){
                        comicsVM.fetchPreviousComic()
                        
                    }
                    
                    Spacer()
                    
                    ButtonView(icon: "arrowshape.turn.up.forward", title:"Next"){
                        comicsVM.fetchNextComic()
                        
                    }
                }
                
                
            }.navigationTitle(comicsVM.title)
            .onTapGesture {
                showingInfo.toggle()
                
            }
            .navigationBarItems(trailing: HStack{
                Button(action: {
                    print("Search")
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                .padding(.trailing)
                
                Button(action: {
                    print("Favourite")
                }, label: {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
            })
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
