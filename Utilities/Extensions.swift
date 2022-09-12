//
//  Extensions.swift
//  GameOfThrones
//
//  Created by Emin on 12.09.2022.
//

import Foundation


extension Encodable {
    
    /// Converts object to pretty print JSONString
    /// - Returns: Json string
    func toJSONString() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
    
}

