//
//  ItemsScenePresenterTests.swift
//  GameOfThronesTests
//
//  Created by Emin on 12.09.2022.
//

import XCTest
@testable import GameOfThrones

class ItemsPresenterTests: XCTestCase {
    
    private var mockWireFrame: MockWireframe!
    private var mockInteractor: MockInteractor!
    private var mockView: MockView!
    
    private var sut: ItemsPresenter!
    
    private var tableView : UITableView = {
        let tableview = UITableView()
        tableview.register(ItemWithImageTableViewCell.self, forCellReuseIdentifier: "ItemWithImageTableViewCell")
        tableview.register(ItemTableViewCell.self, forCellReuseIdentifier: "ItemTableViewCell")
        return tableview
    }()
    
    
    override func setUpWithError() throws {
        mockView = MockView()
        mockInteractor = MockInteractor([])
        mockWireFrame = MockWireframe()
        
    }
    
    
    
    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockWireFrame = nil
    }
    
    func test_GivenItemsCount_WhenNumberOfRowsParamCalled_ThenExpectedToSeeNumberOfRowsEqualToItemsCount() throws {
        
        let characters = JSONTestHelper().readAndDecodeFile(decodeType: CharactersResponse.self, name: "CharactersSuccessResponse")
        
        sut = ItemsPresenter(view: mockView,
                             interactor: mockInteractor,
                             wireframe: mockWireFrame, items: characters)
        XCTAssertEqual(sut.numberOfRows, 22, "Number of rows should be same as provided json file")
    }
    
    
    func test_GivenItemsArray_WhenCellAtIndexCalledForImagedRegion_ThenExpectedToReturnItemWithImageTableViewCell() throws {
        
        let houses = JSONTestHelper().readAndDecodeFile(decodeType: HousesResponse.self, name: "HousesSuccessResponse")
        
        sut = ItemsPresenter(view: mockView,
                             interactor: mockInteractor,
                             wireframe: mockWireFrame, items: houses)
        mockInteractor.items = houses
        // For sorted array houses will be on index 2
        guard let cell = sut.cellAtIndex(index: 2, tableView: tableView) as? ItemWithImageTableViewCell else {
            XCTFail("Cell type should be should be ItemWithImageTableViewCell")
            return
        }
        
        // 2 -> "region": "Dorne"
        XCTAssertEqual(cell.nameLabel.text,"House Amber", "Label not matching")
        XCTAssertNotNil(cell.headerImage?.image,"Image shouldn't be nil")
    }
    
    
    func test_GivenItemsArray_WhenCellAtIndexCalledForRegionWithoutImage_ThenExpectedToReturnItemTableViewCell() throws {
        
        let houses = JSONTestHelper().readAndDecodeFile(decodeType: HousesResponse.self, name: "HousesSuccessResponse")
        
        sut = ItemsPresenter(view: mockView,
                             interactor: mockInteractor,
                             wireframe: mockWireFrame, items: houses)
        mockInteractor.items = houses
        // 14 -> "region": "The Crownlands"
        guard let cell = sut.cellAtIndex(index: 14, tableView: tableView) as? ItemTableViewCell else {
            XCTFail("Cell type should be should be ItemWithImageTableViewCell")
            return
        }
        
        // Houses Type is 2 on API
        XCTAssertEqual(cell.nameLabel.text,"House Baratheon of Dragonstone", "Label not matching")
    }
    
    func test_GivenItemsArray_WhenDidSelectIndexCalled_ThenExpectedToReturnItemTableViewCell() throws {
        
        let houses = JSONTestHelper().readAndDecodeFile(decodeType: HousesResponse.self, name: "HousesSuccessResponse")
        
        sut = ItemsPresenter(view: mockView,
                             interactor: mockInteractor,
                             wireframe: mockWireFrame, items: houses)
        
        mockInteractor.items = houses
        
        sut.didSelectRow(index: 0)
        
        // Houses Type is 2 on API
        XCTAssertTrue(mockWireFrame.isNavigateFunctionCalled, "Navigate function should be called")
        XCTAssertFalse(mockWireFrame.isShowAlertCalled, "Alert shouldn't be called")
        guard let item = mockWireFrame.item as? HousesResponseElement else {
            XCTFail("Item type should be HousesResponse")
            return
        }
        XCTAssertEqual(item.name, "House Algood", "Name is not matching")
        XCTAssertEqual(item.id, "1","Id is not matching")
        XCTAssertEqual(item.region, "The Westerlands","Region is not matching")
        XCTAssertEqual(item.title, "A golden wreath, on a blue field with a gold border(Azure, a garland of laurel within a bordure or)","Title is not matching")
    
    }
    
    
    
}


private class MockView : ItemsViewInterface {
    var stopIndicatorCalled = false
    func stopIndicator() {
        stopIndicatorCalled = true
    }
    
    
}

private class MockInteractor: ItemsInteractorInterface{
    
    
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

private class MockWireframe: ItemsWireframeInterface {

    
    
    var isNavigateFunctionCalled = false
    var isShowAlertCalled = false
    
    var item: ItemsModelProtocol?
    var alertMessage: String?
    
    func navigateToDetailScene(item: ItemsModelProtocol) {
        isNavigateFunctionCalled = true
        self.item = item
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
