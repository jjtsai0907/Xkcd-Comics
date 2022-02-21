//
//  ExplanationSheet.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import SwiftUI

struct ExplanationSheet: View {
    var explainationSheetVM = ExplanationSheetVM()
    var num: Int
    var body: some View {
        Webview(url: explainationSheetVM.getExplanationWebsite(comicNum: num))
    }
}

/*struct ExplanationSheet_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationSheet()
    }
}*/
