//
//  ExplanationSheetVM.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation

class ExplanationViewModel {
    let number: Int
    
    init(number: Int) {
        self.number = number
    }
    
    func getExplanationWebsite(comicNum: Int) -> String {
        return "https://www.explainxkcd.com/wiki/index.php/\(comicNum)"
    }
}
