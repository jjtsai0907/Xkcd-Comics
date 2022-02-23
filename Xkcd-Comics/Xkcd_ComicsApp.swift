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
            ComicsView(viewModel: ComicsViewModel())
        }
    }
}
