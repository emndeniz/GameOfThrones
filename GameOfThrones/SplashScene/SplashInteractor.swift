//
//  SplashInteractor.swift
//  GameOfThrones
//
//  Created by Emin on 10.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class SplashInteractor {
    private var coreDataStack = CoreDataStack()
    private lazy var categoryStore = CategoryStore(managedObjectContext: coreDataStack.mainContext,
                                                   coreDataStack: coreDataStack)
    
    private lazy var serviceProvider = ServiceProvider<CategoriesSevice>()
}

// MARK: - Public Functions -
extension SplashInteractor: SplashInteractorInterface {
    func loadCategories(_ completion:@escaping ((Result<[CategoryItem], Error>) -> Void)) {
        
        let categories = categoryStore.getCategories()
        Logger.log.verbose("Getting categories from DB if exists, categories:", context: categories)
        // Check if Categories are stored in DB or not
        if !categories.isEmpty {
            completion(.success(categories))
        }else {
            fetchCategoriesFromAPI { result in
                completion(result)
            }
        }
    }
    

    
}

// MARK: - Ppivate functions - 
extension SplashInteractor {
    
    ///  Fetches categories from API and returns result in completion block
    /// - Parameter completion: Completion block form API request result
    private func fetchCategoriesFromAPI(_ completion:@escaping ((Result<[CategoryItem], Error>) -> Void)){
        Logger.log.verbose("Fetching categories from API")
        serviceProvider.request(service: .categories, decodeType: CategoriesResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                Logger.log.verbose("Categories fetched successfully, categories:",context: response)
                let itemArray = self.createCategoryItems(response: response)
                self.saveCategoriesToCoreData(categories: itemArray)
                completion(.success(itemArray))
            case .failure(let err):
                Logger.log.error("Failed to fetch categories, error:", context: err)
                completion(.failure(err))
            case .empty:
                Logger.log.error("Response fetched but categories are empty")
                //TODO: Empty cases??
            }
        }
    }
    
    
    /// Saves fetched categories to the Core Data
    /// - Parameter categories: <#categories description#>
    private func saveCategoriesToCoreData(categories:[CategoryItem]){
        Logger.log.verbose("Saving categories to CoreData", context: categories)
        categoryStore.saveCategories(categories: categories)
    }
    
    /// Converts Category API response to required format for CoreData which is CategoryItem
    /// - Parameter response: CategoriesResponseElement array from API response
    /// - Returns: CategoryItem array for CoreData
    private func createCategoryItems(response:[CategoriesResponseElement]) -> [CategoryItem]{
        var itemArray: [CategoryItem] = []
        for element in response {
            if let name = element.categoryName, let type = element.type {
                let item = CategoryItem(name: name, type: type)
                itemArray.append(item)
            }
        }
        Logger.log.verbose("CategoryResponse converted to CategoryItem array, content:", context: itemArray)
        return itemArray
    }
}
