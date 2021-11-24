//
//  ExplanationSheetVM.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation

class ExplanationSheetVM: ObservableObject {

    func getExplanationWebsite(comicNum: Int) -> String{
        return "https://www.explainxkcd.com/wiki/index.php/\(comicNum)"
    }
    
    
}
