//
//  DetailsPresenterTests.swift
//  GameOfThronesTests
//
//  Created by Emin on 12.09.2022.
//
import XCTest
@testable import GameOfThrones

class DetailsPresenterTests: XCTestCase {
    
    private var mockWireFrame: MockWireframe!
    private var mockInteractor: MockInteractor!
    private var mockView: MockView!
    
    private var sut: DetailsPresenter!
    
    override func setUpWithError() throws {
        mockView = MockView()
        mockInteractor = MockInteractor()
        mockWireFrame = MockWireframe()
    }
    
    
    
    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockWireFrame = nil
    }
    
    func test_GivenCharactersResponse_WhenViewDidloadCalled_ThenExpectedToSeeMatchingText() throws {
        
        let characters = JSONTestHelper().readAndDecodeFile(decodeType: CharactersResponse.self, name: "CharactersSuccessResponse")
        let item = characters[0]
        
        sut = DetailsPresenter(view: mockView,
                               interactor: mockInteractor,
                               wireframe: mockWireFrame, item: item)
        
        sut.viewDidLoad()
        
        XCTAssertEqual(mockView.text, item.toJSONString(), "Text not macthing")
        XCTAssertNil(mockView.image, "Image should be nil")
    }
    
    func test_GivenHousesResponseWithoutImage_WhenViewDidloadCalled_ThenExpectedToSeeMatchingTextWithoutImage() throws {
        
        let characters = JSONTestHelper().readAndDecodeFile(decodeType: HousesResponse.self, name: "HousesSuccessResponse")
        let item = characters[14]
        
        sut = DetailsPresenter(view: mockView,
                               interactor: mockInteractor,
                               wireframe: mockWireFrame, item: item)
        
        sut.viewDidLoad()
        
        XCTAssertEqual(mockView.text, item.toJSONString(), "Text not macthing")
        XCTAssertNil(mockView.image, "Image should be nil")
    }

    func test_GivenHousesResponseWithImage_WhenViewDidloadCalled_ThenExpectedToSeeMatchingTextWithImage() throws {
        
        let characters = JSONTestHelper().readAndDecodeFile(decodeType: HousesResponse.self, name: "HousesSuccessResponse")
        let item = characters[1]
        
        sut = DetailsPresenter(view: mockView,
                               interactor: mockInteractor,
                               wireframe: mockWireFrame, item: item)
        
        sut.viewDidLoad()
        
        XCTAssertEqual(mockView.text, item.toJSONString(), "Text not macthing")
        XCTAssertNotNil(mockView.image, "Image shouldn't be nil")
    }
    
    func test_GivenBooksResponse_WhenViewDidloadCalled_ThenExpectedToSeeMatchingText() throws {
        
        let characters = JSONTestHelper().readAndDecodeFile(decodeType: BooksResponse.self, name: "BooksSuccessResponse")
        let item = characters[0]
        
        sut = DetailsPresenter(view: mockView,
                               interactor: mockInteractor,
                               wireframe: mockWireFrame, item: item)
        
        sut.viewDidLoad()
        
        XCTAssertEqual(mockView.text, item.toJSONString(), "Text not macthing")
        XCTAssertNil(mockView.image, "Image should be nil")
    }
    
}


private class MockView : DetailsViewInterface {
    var text: String = ""
    var image: UIImage?
    func updateUI(text: String, image: UIImage?) {
        self.text = text
        self.image = image
    }
    

}

private class MockInteractor: DetailsInteractorInterface{
    
}

private class MockWireframe: DetailsWireframeInterface {
    func showAlert(with title: String?, message: String?) {
        
    }
    
    func showAlert(with title: String?, message: String?, actions: [UIAlertAction]) {
        
    }
    

}
