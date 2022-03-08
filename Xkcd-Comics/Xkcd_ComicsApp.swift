//
//  Xkcd_ComicsApp.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import SwiftUI

@main
struct XkcdComicsApp: App {
    var body: some Scene {
        WindowGroup {
            ComicsView(viewModel: ComicsViewModel(
                        fetchingService: FetchingService(urlSession: URLSession.shared,
                                                         jsonDecoder: JSONDecoder(),
                                                         requestFactory: .init(baseURL: .init(string: "https://xkcd.com/")!)),
                        userDataService: UserDataService(userDefaults: UserDefaults.standard,
                                                         jsonEncoder: JSONEncoder(),
                                                         jsonDecoder: JSONDecoder())))
        }
    }
}
