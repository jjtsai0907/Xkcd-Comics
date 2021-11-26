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
        NavigationView{
            VStack{
                Spacer()
                
                if comicsVM.showingInfo {
                    VStack{
                        
                        Text(comicsVM.comicObject?.alt ?? "Default")
                            .font(.title2)
                            .bold()
                            .padding()
                        
                        Text("Comic Number: \(comicsVM.comicObject?.num ?? -1)  Created: \(comicsVM.comicObject?.month ?? "month")/\(comicsVM.comicObject?.year ?? "year")").foregroundColor(.gray)
                        
                        HStack{
                            ButtonView(icon: "info.circle", title:"Explanation"){
                                comicsVM.showDescription()
                            }.sheet(isPresented: $comicsVM.showingDescription, content:{ExplanationSheet(num: comicsVM.comicObject?.num ?? 100)})
                        }
                    }
                    
                    
                } else {
                    KFImage(URL(string: comicsVM.comicObject?.img ?? "Image"))
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
                
                
            }.navigationTitle(comicsVM.comicObject?.title ?? "Title")
            .onTapGesture {
                comicsVM.showingInfo.toggle()
                
            }
            .navigationBarItems(trailing: HStack{
                
                if comicsVM.showingSearch {
                    TextField("Search..", text: $comicsVM.searchValue)
                        .padding(.trailing)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                        .background(Color(.lightGray))
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                        
                }
                Spacer()
                
                
                IconButtonView(icon: "magnifyingglass"){
                    comicsVM.searchComic(searchNum: comicsVM.searchValue)
                }
                
                IconButtonView(icon: comicsVM.ifSaved ? "heart.fill" : "heart"){
                    comicsVM.saveAsFavourite()
                }
                
                IconButtonView(icon: "person.fill"){
                    comicsVM.getFavouriteComic()
                }
                
            })
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
