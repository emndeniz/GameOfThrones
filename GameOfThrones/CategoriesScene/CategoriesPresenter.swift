//
//  CategoriesPresenter.swift
//  GameOfThrones
//
//  Created by Emin on 10.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class CategoriesPresenter {

    // MARK: - Private properties -

    private unowned let view: CategoriesViewInterface
    private let interactor: CategoriesInteractorInterface
    private let wireframe: CategoriesWireframeInterface
    
    private let categories: [CategoryItem]

    // MARK: - Lifecycle -

    init(
        view: CategoriesViewInterface,
        interactor: CategoriesInteractorInterface,
        wireframe: CategoriesWireframeInterface,
        categories: [CategoryItem]
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        // Store categories by sorted order to show it sorted order
        self.categories = categories.sorted { $0.name < $1.name}
    }
}

// MARK: - Extensions -

extension CategoriesPresenter: CategoriesPresenterInterface {
    func didSelectRow(index: Int) {
        
        let selectedCategory = categories[index]

        interactor.fetchItems(type: selectedCategory.type) { [weak self] result in
            guard let self = self else { return }
            self.view.stopIndicator()
            switch result {
                
            case .success(let data):
                self.wireframe.navigateToItemsScene(items: data)
            case .failure(_):
                let message:String = CategoriesPresenterErrorMessages.failedToFetchCategories(name:selectedCategory.name).description
                self.wireframe.showAlert(with: "Error", message: message)
            }
        }
    }
    
    func categoryAtIndex(index: Int) -> CategoryItem {
        categories[index]
    }
    
    var numberOfRows: Int {
        return categories.count
    }
    
}


enum CategoriesPresenterErrorMessages{
    case failedToFetchCategories(name:String)
    
    var description:String {
        switch self {
        case .failedToFetchCategories(let name):
            return "Failed to fetch data for \(name)"
        }
    }
}
