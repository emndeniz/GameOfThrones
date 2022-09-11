//
//  CategoriesInterfaces.swift
//  GameOfThrones
//
//  Created by Emin on 10.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit


protocol CategoriesWireframeInterface: WireframeInterface {
    func navigateToItemsScene(items:[ItemsModelProtocol])
}

protocol CategoriesViewInterface: ViewInterface {
}

protocol CategoriesPresenterInterface: PresenterInterface {
    var numberOfRows: Int { get }
    func categoryAtIndex(index:Int) -> CategoryItem
    func didSelectRow(index:Int)
}

protocol CategoriesInteractorInterface: InteractorInterface {
    func fetchItems(type:Int, _ completion:@escaping ((Result<[ItemsModelProtocol], APIError>) -> Void))
}
