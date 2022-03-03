//
//  FetchingServiceProtocal.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2022-03-03.
//

import Foundation

protocol FetchingServiceProtocol {
    func fetchComic(comicType: ComicType, completion: @escaping (Result<Comic, FetchingError>) -> Void)
}

enum ComicType {
    case latestComic
    case specificComic(Int)
}
