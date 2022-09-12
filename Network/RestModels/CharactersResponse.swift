//
//  CharsResponse.swift
//  GameOfThrones
//
//  Created by Emin on 8.09.2022.
//

import Foundation

/// This a model struct for  'Chars' type responses
/// https://androidtestmobgen.docs.apiary.io/#reference/0/list-3-retrieve/list-chars

typealias CharactersResponse = [CharactersResponseElement]

struct CharactersResponseElement: ItemsModelProtocol {

    
    let id, name: String?
    let gender: Gender?
    let culture, born, died: String?
    let titles, aliases: [String]?
    let father, mother, spouse: String?
    let allegiances: [String]?
    let playedBy: [String]?
    
    
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
}


