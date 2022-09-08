//
//  GOTServices.swift
//  GameOfThronesTests
//
//  Created by Emin on 8.09.2022.
//

import Foundation


/// This enum handles Categories request to Game of Thrones API.
enum GOTServices {
    case books
    case houses
    case characters
}


extension GOTServices: ServiceBase {
    var path: String {
        
        switch self {
        case .books:
            return "/list/1"
        case .houses:
            return "/list/2"
        case .characters:
            return "/list/3"
        }
    }
    
    var parameters: [String : Any]? {
        // Parameters in these requests should be empty, because the don't require any param.
        return [:]
    }
    
    var method: ServiceMethod {
        return .get
    }
}
