//
//  JSONReader.swift
//  GameOfThronesTests
//
//  Created by Emin on 8.09.2022.
//

import Foundation


/// This is a helper class for Unit Tests to load required response
class JSONTestHelper {
    
    
    /// Reads local json file from test resources
    /// - Parameter name: File name without extension
    /// - Returns: Data represantation of file
    func readLocalFile(name: String) -> Data? {
        do {
            let bundle = Bundle(for: type(of: self))
            if let filePath = bundle.path(forResource: name, ofType: "json"){
                let jsonData = try String(contentsOfFile: filePath).data(using: .utf8)
                return jsonData
            }
        } catch {
            fatalError("Failed to get json")
        }
        return nil
    }
    
    /// Decodes given jsonData to desired object
    /// - Parameters:
    ///   - decodeType: Generic Decodable type
    ///   - jsonData: JSON Data
    /// - Returns: Generic Decodable Type
    func decode<T>(decodeType:T.Type, jsonData:Data) -> T where T:Decodable {
        let decoder = JSONDecoder()

        do {
            let response = try decoder.decode(T.self, from: jsonData)
            return response
        } catch {
            fatalError("Failed to get decodable type")
        }
    }
    
    /// Reads json file and converts it to desired object
    /// - Parameters:
    ///   - decodeType: Generic Decodable type
    ///   - name: File name without extension
    /// - Returns: Generic Decodable Type
    func readAndDecodeFile<T>(decodeType:T.Type, name: String) -> T where T:Decodable {
        guard let data = readLocalFile(name: name) else {
            fatalError("Data is nil")
        }
        return decode(decodeType: decodeType, jsonData: data)
    }
}
