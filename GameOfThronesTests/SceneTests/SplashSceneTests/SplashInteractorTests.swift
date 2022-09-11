//
//  SplashInteractorTests.swift
//  GameOfThronesTests
//
//  Created by Emin on 10.09.2022.
//

import XCTest
@testable import GameOfThrones


class SplashInteractorTests: XCTestCase {
    
    private var mockCategoryStore: MockCategoryStore!
    private var mockServiceProvider: MockServiceProvider!
    private var expectation: XCTestExpectation!
                     
    private var sut: SplashInteractor!
    
    
    private let defaultCategoryItems = [CategoryItem(name: "DBBooks", type: 0),
                             CategoryItem(name: "DBHouses", type: 1),
                             CategoryItem(name: "DBCharacters", type: 2)]
    
    private let defaultCategoryResponses = [CategoriesResponseElement(categoryName: "APIBooks", type: 0),
                                    CategoriesResponseElement(categoryName: "APIHouses", type: 1)]
    
    
    override func setUpWithError() throws {

        mockCategoryStore = MockCategoryStore(defaultCategoryItems)
        mockServiceProvider = MockServiceProvider(defaultCategoryResponses)
        sut = SplashInteractor(categoryStore: mockCategoryStore,
                               serviceProvider: mockServiceProvider)
      
        expectation = expectation(description: "Expectation")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockServiceProvider = nil
        mockCategoryStore = nil
        expectation = nil
    }
    
    func test_GivenPersistencyHasCategories_WhenLoadCategoriesCalled_ThenExpectingToSeePersistedData() throws {
        
        
        // When function called
        sut.loadCategories { result in
            switch result {
                
            case .success(let categories):
                XCTAssert(!categories.isEmpty, "Categories Array shouldn't be empty")
                XCTAssertEqual(categories.count, 3, "We should have 3 categories")
                XCTAssertEqual(categories[0].name, "DBBooks", "Name not matching with DB record")
                XCTAssertEqual(categories[0].type, 0, "Type not matching with DB record")
                XCTAssertEqual(categories[1].name, "DBHouses", "Name not matching with DB record")
                XCTAssertEqual(categories[1].type, 1, "Type not matching with DB record")
                XCTAssertEqual(categories[2].name, "DBCharacters", "Name not matching with DB record")
                XCTAssertEqual(categories[2].type, 2, "Type not matching with DB record")
            case .failure(let err):
                XCTFail("Error was not expected: \(err.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_GivenPersistencyDoesntHaveCategories_WhenLoadCategoriesCalled_ThenExpectingToSeeAPIData() throws {
        // In this case we expecting to see success data from API
        mockCategoryStore.categories = []
        
        sut.loadCategories { result in
            switch result {
                
            case .success(let categories):
                XCTAssert(!categories.isEmpty, "Categories Array shouldn't be empty")
                XCTAssertEqual(categories.count, 2, "We should have 3 categories")
                XCTAssertEqual(categories[0].name, "APIBooks", "Name not matching with DB record")
                XCTAssertEqual(categories[0].type, 0, "Type not matching with DB record")
                XCTAssertEqual(categories[1].name, "APIHouses", "Name not matching with DB record")
                XCTAssertEqual(categories[1].type, 1, "Type not matching with DB record")
            case .failure(let err):
                XCTFail("Error was not expected: \(err.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func test_GivenPersistencyDoesntHaveCategories_WhenLoadCategoriesCalled_ThenExpectingToSeeAPIDataAndCoreDataShouldStoreAPIData() throws {
        // In this case we expecting to see success data from API
        mockCategoryStore.categories = []
        
        sut.loadCategories { result in
            switch result {
                
            case .success(let categories):
                XCTAssert(!categories.isEmpty, "Categories Array shouldn't be empty")
                XCTAssertEqual(categories.count, 2, "We should have 3 categories")
                XCTAssertEqual(categories[0].name, "APIBooks", "Name not matching with DB record")
                XCTAssertEqual(categories[0].type, 0, "Type not matching with DB record")
                XCTAssertEqual(categories[1].name, "APIHouses", "Name not matching with DB record")
                XCTAssertEqual(categories[1].type, 1, "Type not matching with DB record")
                
                
                let dBRecords = self.mockCategoryStore.getCategories()
                
                XCTAssert(!dBRecords.isEmpty, "Categories Array shouldn't be empty")
                XCTAssertEqual(dBRecords.count, 2, "We should have 3 categories")
                XCTAssertEqual(dBRecords[0].name, "APIBooks", "Name not matching with DB record")
                XCTAssertEqual(dBRecords[0].type, 0, "Type not matching with DB record")
                XCTAssertEqual(dBRecords[1].name, "APIHouses", "Name not matching with DB record")
                XCTAssertEqual(dBRecords[1].type, 1, "Type not matching with DB record")
                
            case .failure(let err):
                XCTFail("Error was not expected: \(err.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func test_GivenPersistencyDoesntHaveCategories_WhenLoadCategoriesCalledAndAPIReturnsError_ThenExpectingToSeeError() throws {
        // In this case we expecting to see error from API
        mockCategoryStore.categories = []
        mockServiceProvider.categories = []
        mockServiceProvider.isReturnFailure = true
        
        sut = SplashInteractor(categoryStore: mockCategoryStore,
                               serviceProvider: mockServiceProvider)
        
        sut.loadCategories { result in
            switch result {
                
            case .success(let categories):
                XCTFail("Success is not expected")
                
            case .failure(let error):
                let err = error as! APIError
                XCTAssertEqual(err.localizedDescription, APIError.invalidData.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
}


private class MockCategoryStore : CategoryStoreProtocol {
    
    var categories : [CategoryItem]
    init(_ categories: [CategoryItem]){
        self.categories = categories
    }
    
    func getCategories() -> [CategoryItem] {
        return categories
    }
    
    func saveCategories(categories: [CategoryItem]) -> [CategoriesData] {
        self.categories = categories
        return []
    }
}


private class MockServiceProvider : ServiceProvider<CategoriesSevice> {
    var categories : CategoriesResponse
    var isReturnFailure: Bool
    
    init(_ categories: CategoriesResponse, _ isReturnFailure:Bool = false){
        self.categories = categories
        self.isReturnFailure = isReturnFailure
    }
    
    override func request<U>(service:CategoriesSevice, decodeType: U.Type, completion: @escaping ((ServiceResult<U>) -> Void)) where U: Decodable {
        if isReturnFailure {
           // completion(.failure(.responseUnsuccessful(NSError(domain: "Not Found", code: 404))))
            completion(.failure(.invalidData))
        }else {
            completion(.success(categories as! U))
        }
    }
}
