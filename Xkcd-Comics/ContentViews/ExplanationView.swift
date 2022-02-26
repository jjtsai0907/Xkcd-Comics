//
//  ExplanationSheet.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import SwiftUI

struct ExplanationView: View {
    let viewModel: ExplanationViewModel
    
    var body: some View {
        Webview(url: viewModel.getExplanationWebsite())
    }
}

struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView(viewModel: ExplanationViewModel(number: 2))
    }
}
