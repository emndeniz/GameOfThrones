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
        coreDataStack = nil
        categoryStore = nil
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
        // Save categories to Core Data to call it on get.
        categoryStore.saveCategories(categories: [category1,category2])
        
        // When
        let categories = categoryStore.getCategories()
        
        XCTAssertNotNil(categories, "Report should not be nil")
        XCTAssertEqual(categories.count, 2, "There should be 2 item")
        XCTAssertEqual(categories[0].name, "Books","First category name should be books")
        XCTAssertEqual(categories[0].type, 0,"First category type should be books")
        XCTAssertEqual(categories[1].name, "Houses","Second category name should be books")
        XCTAssertEqual(categories[1].type, 1,"Second category type should be books")
    }
  


}
