//
//  JSONReader.swift
//  GameOfThronesTests
//
//  Created by Emin on 8.09.2022.
//

import Foundation


/// This is a helper class for Unit Tests to load required response
class JSONReader {
    
    func readLocalFile(forName name: String) -> Data? {
        do {
            let bundle = Bundle(for: type(of: self))
            if let filePath = bundle.path(forResource: name, ofType: "json"){
                let jsonData = try String(contentsOfFile: filePath).data(using: .utf8)
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
}
