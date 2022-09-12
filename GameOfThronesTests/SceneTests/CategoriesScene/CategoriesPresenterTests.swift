//
//  CategoriesPresenterTests.swift
//  GameOfThronesTests
//
//  Created by Emin on 11.09.2022.
//

import Foundation


import XCTest
@testable import GameOfThrones

class CategoriesPresenterTests: XCTestCase {

    
    private var mockWireFrame: MockWireframe!
    private var mockInteractor: MockInteractor!
    private var mockView: MockView!
    
    var sut: CategoriesPresenter!

    
    private let defaultCategoryItems = [CategoryItem(name: "Books", type:1),
                             CategoryItem(name: "Houses", type:2),
                             CategoryItem(name: "Characters", type:3)]
    
    override func setUpWithError() throws {
        mockView = MockView()
        mockInteractor = MockInteractor([])
        mockWireFrame = MockWireframe()
        sut = CategoriesPresenter(view: mockView,
                              interactor: mockInteractor,
                                  wireframe: mockWireFrame, categories: defaultCategoryItems)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockWireFrame = nil
    }

    func test_GivenCategoriesCount_WhenNumberOfRowsParamCalled_ThenExpectedToSeeNumberOfRowsEqualToCategoriesCount() throws {
        
        XCTAssertEqual(sut.numberOfRows, defaultCategoryItems.count, "Number of rows should be same as defaultCategoryItems count.")
    }
    
    func test_GivenCategoriesArray_WhenCategoriesAtIndexCalleed_ThenExpectedToSortedArray() throws {
        
        var namesArrayAtPresenter:[String] = []
        
        //Fetch all item names in presenter
        for index in 0..<defaultCategoryItems.count {
            let itemNameAtPresenter = sut.categoryAtIndex(index: index).name
            namesArrayAtPresenter.append(itemNameAtPresenter)
        }
        
        // Check if they are sorted
        XCTAssertTrue(namesArrayAtPresenter.isAscending(),"Names should be ascending ordered")
        
        
    }
    
    func test_GivenCategoriesArray_WhenDidSelectCalledForSecondElement_ThenExpectedToSeeTypeOne() throws {
        
        let houses = JSONTestHelper().readAndDecodeFile(decodeType: HousesResponse.self, name: "HousesSuccessResponse")
        
        mockInteractor.items = houses
        // For sorted array houses will be on index 2
        sut.didSelectRow(index: 2)
        
        // Houses Type is 2 on API
        XCTAssertEqual(mockInteractor.itemType,2,"Item type should be matching")
       
        XCTAssertTrue(mockWireFrame.isNavigateFunctionCalled,"Navigate Fucntion should be called")
        XCTAssertFalse(mockWireFrame.isShowAlertCalled, "Alert shouldn't be called")
        XCTAssertEqual(mockWireFrame.items?.count, 50)
        
    }
    
    
    func test_GivenFailResponse_WhenDidSelectRowCalledForAnyType_ThenExpectedToSeeAlert() throws {
        
       
        let selectedCategory = defaultCategoryItems[0]
        
        mockInteractor.isReturnFailure = true
        // For sorted array houses will be on index 2
        sut.didSelectRow(index: 0)
        
        // Houses Type is 1 on API
        XCTAssertEqual(mockInteractor.itemType,selectedCategory.type,"Item type should be matching")
       
        XCTAssertFalse(mockWireFrame.isNavigateFunctionCalled,"Navigate Fucntion should not be called")
        XCTAssertTrue(mockWireFrame.isShowAlertCalled, "Alert should be called")
        XCTAssertEqual(mockWireFrame.alertMessage, CategoriesPresenterErrorMessages.failedToFetchCategories(name:selectedCategory.name).description, "Alert message not matched")
        
    }
    
    func test_GivenAnySuccessResponse_WhenDidSelectRowCalledForAnyType_ThenExpectedToSeeStopIndicatorFunctionCalled() throws {
        sut.didSelectRow(index: 0)
        
        XCTAssertTrue(mockView.stopIndicatorCalled,"FecthCompleted function should be called")
    }
    
    func test_GivenAnyFail_WhenDidSelectRowCalledForAnyType_ThenExpectedToSeeStopIndicatorFunctionCalled() throws {
        mockInteractor.isReturnFailure = true
        
        sut.didSelectRow(index: 0)
        
        XCTAssertTrue(mockView.stopIndicatorCalled,"FecthCompleted function should be called")
    }

}


private class MockView : CategoriesViewInterface {
    var stopIndicatorCalled = false
    func stopIndicator() {
        stopIndicatorCalled = true
    }
    
    
}


private class MockInteractor: CategoriesInteractorInterface{
    
    
    var items : [ItemsModelProtocol]
    var isReturnFailure: Bool
    var itemType : Int = 0
    
    init(_ items: [ItemsModelProtocol], _ isReturnFailure:Bool = false){
        self.items = items
        self.isReturnFailure = isReturnFailure
    }
    
    func fetchItems(type: Int, _ completion: @escaping ((Result<[ItemsModelProtocol], APIError>) -> Void)) {
        itemType = type
        if isReturnFailure {
            completion(.failure(.invalidData))
        }else {
            completion(.success(items))
        }
    }
    
}

private class MockWireframe: CategoriesWireframeInterface {

    var isNavigateFunctionCalled = false
    var isShowAlertCalled = false
    
    var items: [ItemsModelProtocol]?
    var alertMessage: String?
    
    func navigateToItemsScene(items: [ItemsModelProtocol]) {
        isNavigateFunctionCalled = true
        self.items = items
    }
    
    func showAlert(with title: String?, message: String?) {
        isShowAlertCalled = true
        self.alertMessage = message
    }
    
    func showAlert(with title: String?, message: String?, actions: [UIAlertAction]) {
        isShowAlertCalled = true
        self.alertMessage = message
    }
    
    
}


extension Array where Element: Comparable {
    func isAscending() -> Bool {
        return zip(self, self.dropFirst()).allSatisfy(<=)
    }
}
