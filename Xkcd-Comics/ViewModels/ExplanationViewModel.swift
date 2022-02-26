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
    
    func getExplanationWebsite() -> String {
        return "\(WebsiteAddress.websiteBaseAddress)\(number)"
    }
    
    private enum WebsiteAddress {
        static let websiteBaseAddress = "https://www.explainxkcd.com/wiki/index.php/"
    }
}
