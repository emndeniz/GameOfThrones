//
//  CategoriesResponses.swift
//  GameOfThrones
//
//  Created by Emin on 8.09.2022.
//

import Foundation


/// This a model struct for  'Categories' type responses
/// https://androidtestmobgen.docs.apiary.io/#reference/0/categories-collection/list-all-categories
typealias CategoriesResponse = [CategoriesResponseElement]

struct CategoriesResponseElement: Codable {
    let categoryName: String?
    let type: Int?

    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
        case type
    }
}


