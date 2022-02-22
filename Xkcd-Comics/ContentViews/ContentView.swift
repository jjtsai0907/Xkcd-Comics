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
        NavigationView {
            VStack {
                Spacer()
                if comicsVM.showingInfo {
                    VStack {
                        Text(comicsVM.comicObject.alt)
                            .font(.title2)
                            .bold()
                            .padding()
                        Text("Comic Number: \(comicsVM.comicObject.num)  Created: \(comicsVM.comicObject.month )/\(comicsVM.comicObject.year)")
                            .foregroundColor(.gray)
                        HStack {
                            ButtonView(icon: "info.circle", title: "Explanation") {
                                comicsVM.showDescription()
                            }.sheet(isPresented: $comicsVM.showingExplanation, content: { ExplanationSheet(num: comicsVM.comicObject.num) })
                        }
                    }
                } else {
                    KFImage(URL(string: comicsVM.comicObject.img))
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                Spacer()
                HStack {
                    ButtonView(icon: "arrowshape.turn.up.backward", title: "Previous") {
                        comicsVM.fetchPreviousComic()
                    }
                    .alert(isPresented: $comicsVM.showingPreviousComicAlert) {
                        Alert(
                            title: Text("More Comic?"),
                            message: Text("This is our very first comic ^3^")
                        )
                    }
                    Spacer()
                    ButtonView(icon: "arrowshape.turn.up.forward", title: "Next") {
                        comicsVM.fetchNextComic()
                    }.alert(isPresented: $comicsVM.showingNextComicAlert) {
                        Alert(
                            title: Text("New Comic?"),
                            message: Text("This is our latest comic! Come back tomorrow ^3^")
                        )
                    }
                }
            }.navigationTitle(comicsVM.comicObject.title)
            .onTapGesture {
                comicsVM.showingInfo.toggle()
            }
            .navigationBarItems(trailing: HStack {
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
                IconButtonView(icon: "magnifyingglass") {
                    comicsVM.searchComic(searchNum: comicsVM.searchValue)
                }
                IconButtonView(icon: comicsVM.ifSaved ? "heart.fill" : "heart") {
                    comicsVM.saveAsFavourite(comic: comicsVM.comicObject)
                }
                IconButtonView(icon: "person.fill") {
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
