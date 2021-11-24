//
//  Comics.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation

struct Comic: Codable {
    let num: Int
    let title: String
    let img: String
    let alt: String
}
