//
//  HousesResponse.swift
//  GameOfThrones
//
//  Created by Emin on 8.09.2022.
//

import Foundation

/// This a model struct for  'Houses' type responses
/// https://androidtestmobgen.docs.apiary.io/#reference/0/list-2-retrieve/list-houses

typealias HousesResponse = [HousesResponseElement]

struct HousesResponseElement: Decodable, ItemsModelProtocol {
    let id, name, region, title: String?
    
}


