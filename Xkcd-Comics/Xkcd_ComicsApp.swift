//
//  Xkcd_ComicsApp.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import SwiftUI

@main
struct Xkcd_ComicsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ComicsVM())
        }
    }
}
