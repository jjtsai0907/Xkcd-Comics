//
//  ContentView.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import SwiftUI
import Kingfisher

struct ComicsView: View {
    @ObservedObject var viewModel: ComicsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                if viewModel.isShowingInfo {
                    VStack {
                        Text(viewModel.comic.alt)
                            .font(.title2)
                            .bold()
                            .padding()
                        
                        Text("Comic Number: \(viewModel.comic.num) Created: \(viewModel.comic.month )/\(viewModel.comic.year)")
                            .foregroundColor(.gray)
                        
                        HStack {
                            CustomButton(icon: "info.circle", title: "Explanation") {
                                viewModel.toggleDescription()
                            }.sheet(isPresented: $viewModel.isShowingExplanation) {
                                ExplanationView(viewModel: ExplanationViewModel(number: viewModel.comic.num))
                            }
                        }
                    }
                } else {
                    KFImage(URL(string: viewModel.comic.img))
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                Spacer()
                
                HStack {
                    CustomButton(icon: "arrowshape.turn.up.backward", title: "Previous") {
                        viewModel.fetchPreviousComic()
                    }
                    .alert(isPresented: $viewModel.isShowingPreviousComicAlert) {
                        Alert(
                            title: Text("More Comic?"),
                            message: Text("This is our very first comic ^3^")
                        )
                    }
                    Spacer()
                    
                    CustomButton(icon: "arrowshape.turn.up.forward", title: "Next") {
                        viewModel.fetchNextComic()
                    }.alert(isPresented: $viewModel .isShowingNextComicAlert) {                        
                        Alert(
                            title: Text("New Comic?"),
                            message: Text("This is our latest comic! Come back tomorrow ^3^")
                        )
                    }
                }
            }.navigationTitle(viewModel.comic.title)
            .onTapGesture {
                viewModel.toggleInfo()
            }
            .navigationBarItems(trailing: HStack {
                if viewModel.isShowingSearch {
                    TextField("Search..", text: $viewModel.searchValue)
                        .padding(.trailing)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                        .background(Color(.lightGray))
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                }
                Spacer()
                CustomIconButton(icon: "magnifyingglass") {
                    viewModel.searchComic(searchNum: viewModel.searchValue)
                }
                CustomIconButton(icon: viewModel.isSaved ? "heart.fill" : "heart") {
                    viewModel.saveAsFavourite(comic: viewModel.comic)
                }
                CustomIconButton(icon: "person.fill") {
                    viewModel.getFavouriteComics()
                }
            })
        }
    }    
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView(viewModel: ComicsViewModel())
    }
}
