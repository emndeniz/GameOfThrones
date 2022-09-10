//
//  BooksResponse.swift
//  GameOfThrones
//
//  Created by Emin on 8.09.2022.
//

import Foundation


/// This a model struct for  'Books' type responses
/// https://androidtestmobgen.docs.apiary.io/#reference/0/list-1-retrieve/list-books
struct BooksResponseElement: Codable, ItemsModelProtocol {
    let name, isbn: String?
    let authors: [String]?
    let numberOfPages: Int?
    let publisher, country, mediaType, released: String?
}

typealias BooksResponse = [BooksResponseElement]
