//
//  SplashPresenterTests.swift
//  GameOfThronesTests
//
//  Created by Emin on 10.09.2022.
//

import XCTest
@testable import GameOfThrones

class SplashPresenterTests: XCTestCase {

    
    private var mockWireFrame: MockWireframe!
    private var mockInteractor: MockInteractor!
    private var mockView: MockView!
    
    var sut: SplashPresenter!
    
    private let defaultCategoryItems = [CategoryItem(name: "DBBooks", type: 0),
                             CategoryItem(name: "DBHouses", type: 1),
                             CategoryItem(name: "DBCharacters", type: 2)]
    

    override func setUpWithError() throws {
        mockView = MockView()
        mockInteractor = MockInteractor(defaultCategoryItems)
        mockWireFrame = MockWireframe()
        sut = SplashPresenter(view: mockView,
                              interactor: mockInteractor,
                              wireframe: mockWireFrame)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockWireFrame = nil
    }

    func test_GivenCategoriesExist_WhenViewDidLoadCalled_ThenExpectedToCallNavigateFunction() throws {
        sut.viewDidLoad()

        XCTAssertTrue(mockWireFrame.isNavigateFunctionCalled,"Navigate Fucntion should be called")
        XCTAssertFalse(mockWireFrame.isShowAlertCalled, "Alert shouldn't be called")
        
        
        XCTAssertEqual(mockWireFrame.categories?.count, 3, "There should be 3 category")
        XCTAssertEqual(mockWireFrame.categories?[0].name, "DBBooks", "Name not maching")
        XCTAssertEqual(mockWireFrame.categories?[0].type, 0, "Type not maching")
        XCTAssertEqual(mockWireFrame.categories?[1].name, "DBHouses", "Name not maching")
        XCTAssertEqual(mockWireFrame.categories?[1].type, 1, "Type not maching")
    }

    
    func test_GivenCategoriesDoesntExist_WhenViewDidLoadCalled_ThenExpectedToCallAlertFunction() throws {
        mockInteractor.categories = []
        mockInteractor.isReturnFailure = true
        sut.viewDidLoad()

        XCTAssertFalse(mockWireFrame.isNavigateFunctionCalled,"Navigate Fucntion shouldn't be called")
        XCTAssertTrue(mockWireFrame.isShowAlertCalled, "Alert should be called")
        
        XCTAssertEqual(mockWireFrame.alertMessage, SplashPresenterErrorMessages.failedToFetchCategories.rawValue, "Alert message not matched")
    }

}


private class MockView : SplashViewInterface {
    
}


private class MockInteractor: SplashInteractorInterface{
    
    var categories : [CategoryItem]
    var isReturnFailure: Bool
    
    init(_ categories: [CategoryItem], _ isReturnFailure:Bool = false){
        self.categories = categories
        self.isReturnFailure = isReturnFailure
    }
    
    func loadCategories(_ completion: @escaping ((Result<[CategoryItem], Error>) -> Void)) {
        if isReturnFailure {
            completion(.failure(NSError(domain: "Not Found", code: 404)))
        }else {
            completion(.success(categories))
        }
    }
    
    
}

private class MockWireframe: SplashWireframeInterface {
    
    var isNavigateFunctionCalled = false
    var isShowAlertCalled = false
    
    var categories: [CategoryItem]?
    var alertMessage: String?
    
    func navigateToategories(categories:[CategoryItem]) {
        isNavigateFunctionCalled = true
        self.categories = categories
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
