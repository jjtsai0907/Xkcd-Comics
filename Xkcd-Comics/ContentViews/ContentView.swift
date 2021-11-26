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
                        //Text()
                        
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
                Button(action: {
                    comicsVM.searchComic(searchNum: comicsVM.searchValue)
                    print("Search")
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                .padding(.trailing)
                
                Button(action: {
                    comicsVM.saveAsFavourite()
                }, label: {
                    if comicsVM.ifSaved {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                    } else {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    
                }).padding(.trailing)
                
                Button(action: {
                    comicsVM.getFavouriteComic()
                }, label: {
                    Image(systemName: "square.and.arrow.down.on.square.fill")
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
