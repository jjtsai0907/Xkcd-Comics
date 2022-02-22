//
//  ContentView.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @StateObject var viewModel : ComicsVM
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                if viewModel.showingInfo {
                    VStack{
                        
                        Text(viewModel.comicObject.alt)
                            .font(.title2)
                            .bold()
                            .padding()
                        
                        Text("Comic Number: \(viewModel.comicObject.num)  Created: \(viewModel.comicObject.month )/\(viewModel.comicObject.year)").foregroundColor(.gray)
                        
                        HStack{
                            ButtonView(icon: "info.circle", title:"Explanation"){
                                viewModel.showDescription()
                            }.sheet(isPresented: $viewModel.showingExplanation, content:{ExplanationSheet(viewModel: ExplanationSheetVM(), num: viewModel.comicObject.num)})
                        }
                    }
                } else {
                    KFImage(URL(string: viewModel.comicObject.img))
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                Spacer()
                
                HStack{
                    ButtonView(icon: "arrowshape.turn.up.backward", title:"Previous"){
                        viewModel.fetchPreviousComic()
                    }
                    .alert(isPresented: $viewModel.showingPreviousComicAlert) {
                        
                        Alert(
                            title: Text("More Comic?"),
                            message: Text("This is our very first comic ^3^")
                        )
                    }
                    Spacer()
                    
                    ButtonView(icon: "arrowshape.turn.up.forward", title:"Next"){
                        viewModel.fetchNextComic()
                        
                    }.alert(isPresented: $viewModel .showingNextComicAlert) {
                        
                        Alert(
                            title: Text("New Comic?"),
                            message: Text("This is our latest comic! Come back tomorrow ^3^")
                        )
                    }
                }
                
                
            }.navigationTitle(viewModel.comicObject.title)
            .onTapGesture {
                viewModel.showingInfo.toggle()
                
            }
            .navigationBarItems(trailing: HStack{
                
                if viewModel.showingSearch {
                    TextField("Search..", text: $viewModel.searchValue)
                        .padding(.trailing)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                        .background(Color(.lightGray))
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                        
                }
                Spacer()
                
                
                IconButtonView(icon: "magnifyingglass"){
                    viewModel.searchComic(searchNum: viewModel.searchValue)
                }
                
                IconButtonView(icon: viewModel.ifSaved ? "heart.fill" : "heart"){
                    viewModel.saveAsFavourite(comic: viewModel.comicObject)
                }
                
                IconButtonView(icon: "person.fill"){
                    viewModel.getFavouriteComic()
                }
            })
        }
    }    
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
