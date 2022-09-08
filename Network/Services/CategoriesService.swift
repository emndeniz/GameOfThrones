//
//  CategoriesService.swift
//  GameOfThrones
//
//  Created by Emin on 8.09.2022.
//

import Foundation


/// This enum handles Categories request to Game of Thrones API.
enum CategoriesSevice {
    case categories
}

extension CategoriesSevice : ServiceBase {
    var path: String {
        return "/categories"
    }
    
    var parameters: [String : Any]? {
        // Paramters in Categories request should be empty, because it doesn't require any param.
        return [:]
    }
    
    var method: ServiceMethod {
        return .get
    }    
}
