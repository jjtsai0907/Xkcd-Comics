//
//  Comics.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation

struct Comic: Codable, Equatable {
    let num: Int
    let title: String
    let img: String
    let alt: String
    let year: String
    let month: String
}
