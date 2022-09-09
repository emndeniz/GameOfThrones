//
//  CategoryStore.swift
//  GameOfThrones
//
//  Created by Emin on 9.09.2022.
//

import Foundation
import CoreData

protocol CategoryStoreProtocol {
    func getCategories() -> [CategoryItem]
    func saveCategories(categories:[CategoryItem])
}

class CategoryStore: CategoryStoreProtocol {

    // MARK: - Properties
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    // MARK: - Initializers
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
      self.managedObjectContext = managedObjectContext
      self.coreDataStack = coreDataStack
    }
    
    /// Returns stored category items from Core Data
    /// - Returns: CategoryItem Array
    func getCategories() -> [CategoryItem] {
       return getCategoryItems()
    }
    
    /// Saves given CategoryItems array to the Core Data
    /// - Parameter categories: <#categories description#>
    func saveCategories(categories: [CategoryItem]) {
        saveCategoryItems(categories: categories)
    }
    
}

//MARK: - Core Data Functions-

extension CategoryStore {
    
    /// Gets all Category Items in Core Data
    /// - Returns: CategoryItem array
    private func getCategoryItems() -> [CategoryItem]{
        let catogoryDataItems = loadCategoryCoreData()
        var categories: [CategoryItem] = []
        
        for item in catogoryDataItems {
            guard let name = item.name else {
                print("Nil data found for category item, skipping it. \(item)")
                continue
            }
            let categoryItem = CategoryItem(name: name, type: Int(item.type))
            categories.append(categoryItem)
        }
        return categories
    }
    
    /// Saves  CategoryItem array to Core Data
    /// - Parameter categories: CatoryItem array
    private func saveCategoryItems(categories: [CategoryItem]){
        
        for category in categories {
            let categoryData = CategoriesData(context:managedObjectContext)
            categoryData.name = category.name
            categoryData.type = Int16(category.type)
        }
        
        coreDataStack.saveContext()
    }
    
    /// Loads items from Core Data
    /// - Returns: Categories Data Array
    private func loadCategoryCoreData() -> [CategoriesData]{

        let request: NSFetchRequest<CategoriesData> = CategoriesData.fetchRequest()
        
        do {
            let items = try managedObjectContext.fetch(request)
            return items
        }  catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
    
}
