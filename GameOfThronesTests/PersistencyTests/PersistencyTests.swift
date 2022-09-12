//
//  PersistencyTests.swift
//  GameOfThronesTests
//
//  Created by Emin on 9.09.2022.
//

import XCTest
import CoreData

@testable import GameOfThrones

class PersistencyTests: XCTestCase {

    
    var categoryStore: CategoryStore!
    var coreDataStack: CoreDataStack!
    
    override func setUpWithError() throws {
        coreDataStack = TestCoreDataStack()
        categoryStore = CategoryStore(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }

    override func tearDownWithError() throws {
        deleteAllPersistedData()
        coreDataStack = nil
        categoryStore = nil
        
    }
    
    /// Clean ups all persisted data for next tests
    private func deleteAllPersistedData(){
        var objects: [CategoriesData] = []
        let request: NSFetchRequest<CategoriesData> = CategoriesData.fetchRequest()
        
        do {
            objects = try coreDataStack.mainContext.fetch(request)
        }  catch let error as NSError{
            fatalError("Couldn't fetched")
        }
        
        for obj in objects {
            coreDataStack.mainContext.delete(obj)
        }
    }

    func test_GivenCategories_WhenSaveFunctionCalled_ThenCategoriesShouldStoredInCoreData() throws {
        // Given
        let category1 = CategoryItem(name: "Books", type: 0)
        let category2 = CategoryItem(name: "Houses", type: 1)

        // When
        let result = categoryStore.saveCategories(categories: [category1,category2])

        // Then
        XCTAssertNotNil(result, "Report should not be nil")
        XCTAssertEqual(result.count, 2, "There should be 2 item")
        XCTAssertEqual(result[0].name, "Books","First category name should be books")
        XCTAssertEqual(result[0].type, 0,"First category type should be books")
        XCTAssertEqual(result[1].name, "Houses","Second category name should be books")
        XCTAssertEqual(result[1].type, 1,"Second category type should be books")

    }
    
    
    func test_GivenCategories_WhenGetFunctionCalled_ThenCategoriesShouldMacthedPreviousStoredData(){
        // Given
        let category1 = CategoryItem(name: "Books", type: 0)
        let category2 = CategoryItem(name: "Houses", type: 1)
        var categoryArray = [category1,category2]
        // Save categories to Core Data to call it on get.
        categoryStore.saveCategories(categories: categoryArray)
        
        // When
        let categories = categoryStore.getCategories()
        
        XCTAssertNotNil(categories, "Report should not be nil")
        XCTAssertEqual(categories.count, 2, "There should be 2 item")
        
        for category in categories {
            
            if category.name == category1.name {
                XCTAssertEqual(category.type, 0,"Category type should be books")
            }else {
                XCTAssertEqual(category.type, 1,"Category type should be Houses")
            }
            
            let index = categoryArray.firstIndex { item in
                item.name == category.name
            }
            
            // Remove elements to ensure elements are correct
            categoryArray.remove(at: index!)
        }
        XCTAssertEqual(categoryArray.count, 0,"Categories array shouşd be empty")

    }

}
