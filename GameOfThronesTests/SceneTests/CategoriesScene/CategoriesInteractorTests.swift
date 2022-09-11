//
//  CategoriesInteractorTests.swift
//  GameOfThronesTests
//
//  Created by Emin on 10.09.2022.
//

import XCTest
@testable import GameOfThrones


class CategoriesInteractorTests: XCTestCase {
    
    private var mockServiceProvider: MockServiceProvider!
    private var expectation: XCTestExpectation!
    
    private var sut: CategoriesInteractor!
    
    
    override func setUpWithError() throws {
        
        mockServiceProvider = MockServiceProvider([])
        sut = CategoriesInteractor(serviceProvider: mockServiceProvider)
        
        expectation = expectation(description: "Expectation")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockServiceProvider = nil
        expectation = nil
    }
    
    //MARK: - Success Cases -
    func test_GivenAppHasSuccessfullBooksResponses_WhenFetchItemsCalled_ThenExpectingToSeeSuccessfullData() throws {
        // Get Sample data
        let books = JSONTestHelper().readAndDecodeFile(decodeType: BooksResponse.self, name: "BooksSuccessResponse")
        
        mockServiceProvider.items = books
        
        // When function called
        sut.fetchItems(type: GOTServices.books.rawValue) { result in
            switch result {
                
            case .success(let items):
                XCTAssert(!items.isEmpty, "Array shouldn't be empty")
                XCTAssertEqual(items.count, 9, "We should have 3 categories")
                
                guard let firstBook = items[0] as? BooksResponseElement else {
                    XCTFail("Item Type should be book")
                    return
                }
              
                XCTAssertEqual(firstBook.name, "A Game of Thrones", "Book name is not correct")
                XCTAssertEqual(firstBook.isbn, "978-0553103540", "ISBN name is not correct")
                XCTAssertEqual(firstBook.authors, [
                    "George R. R. Martin"
                ], "Authors are not correct")
                XCTAssertEqual(firstBook.numberOfPages, 694, "Number of pages are incorrect")
                XCTAssertEqual(firstBook.publisher, "Bantam Books", "Publisher is incorrect")
                XCTAssertEqual(firstBook.country, "United States", "Country is incorrect")
                XCTAssertEqual(firstBook.mediaType, "Hardcover", "Media type is incorrect")
                XCTAssertEqual(firstBook.released, "1996-08-01T00:00:00", "Release date is incorrect")
            
            case .failure(let err):
                XCTFail("Error was not expected: \(err.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func test_GivenAppHasSuccessfullHousesResponses_WhenFetchItemsCalled_ThenExpectingToSeeSuccessfullData() throws {
        // Get Sample data
        let houses = JSONTestHelper().readAndDecodeFile(decodeType: HousesResponse.self, name: "HousesSuccessResponse")
        
        mockServiceProvider.items = houses
        
        // When function called
        sut.fetchItems(type: GOTServices.houses.rawValue) { result in
            switch result {
                
            case .success(let items):
                XCTAssert(!items.isEmpty, "Array shouldn't be empty")
                XCTAssertEqual(items.count, 50, "We should have 3 categories")
                
                guard let firstHouse = items[0] as? HousesResponseElement else {
                    XCTFail("Item Type should be book")
                    return
                }
                
                XCTAssertEqual(firstHouse.name, "House Algood","Name is incorrect")
                XCTAssertEqual(firstHouse.id, "1", "ID is incorrect")
                XCTAssertEqual(firstHouse.region, "The Westerlands", "Region is incorrect")
                XCTAssertEqual(firstHouse.title, "A golden wreath, on a blue field with a gold border(Azure, a garland of laurel within a bordure or)", "Title is incorrect")
              
            
            case .failure(let err):
                XCTFail("Error was not expected: \(err.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }

    
    func test_GivenAppHasSuccessfullCharactersResponses_WhenFetchItemsCalled_ThenExpectingToSeeSuccessfullData() throws {
        // Get Sample data
        let characters = JSONTestHelper().readAndDecodeFile(decodeType: CharactersResponse.self, name: "CharactersSuccessResponse")
        
        mockServiceProvider.items = characters
        
        // When function called
        sut.fetchItems(type: GOTServices.characters.rawValue) { result in
            switch result {
                
            case .success(let items):
                XCTAssert(!items.isEmpty, "Array shouldn't be empty")
                XCTAssertEqual(items.count, 22, "We should have 3 categories")
                
                guard let tywin = items[3] as? CharactersResponseElement else {
                    XCTFail("Item Type should be book")
                    return
                }
                XCTAssertEqual(tywin.id, "27", "ID is incorrect")
                XCTAssertEqual(tywin.name, "Tywin Lannister", "Name is incorrect")
                XCTAssertEqual(tywin.gender, Gender.male, "Gender is incorrect")
                XCTAssertEqual(tywin.culture, "", "Culture is incorrect")
                XCTAssertEqual(tywin.born, "In 242 AC", "Born is incorrect")
                XCTAssertEqual(tywin.died, "In 300 AC, at King's Landing", "Died is incorrect")
                XCTAssertEqual(tywin.titles,  [
                    "Lord of Casterly Rock",
                    "Shield of Lannisport",
                    "Warden of the West",
                    "Hand of the King",
                    "Savior of the City (of King's Landing)"
                ], "Titles are incorrect")
                XCTAssertEqual(tywin.aliases, [
                    "The Lion of Lannister",
                    "The Old Lion",
                    "The Great Lion of the Rock"
                ], "Aliases are incorrect")
                XCTAssertEqual(tywin.father, "", "Father is incorrect")
                XCTAssertEqual(tywin.mother, "", "Mother is incorrect")
                XCTAssertEqual(tywin.spouse, "562", "Spouse is incorrect")
                XCTAssertEqual(tywin.allegiances,[
                    "http://www.anapioficeandfire.com/api/houses/229"
                ], "Allegiances date is incorrect")
                XCTAssertEqual(tywin.playedBy, [
                    "Charles Dance"
                ], "Played by is incorrect")
                
            
            case .failure(let err):
                XCTFail("Error was not expected: \(err.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    //MARK: - Fail & Edge Cases -
    
    func test_GivenAppHasFailBooksResponses_WhenFetchItemsCalled_ThenExpectingToSeeError() throws {
        mockServiceProvider.isReturnFailure = true
        
        // When function called
        sut.fetchItems(type: GOTServices.books.rawValue) { result in
            switch result {
                
            case .success(_):
                XCTFail("Success was not expected")
            
            case .failure(let err):
                XCTAssertEqual(err.localizedDescription, APIError.invalidData.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func test_GivenAppHasFailHousesResponses_WhenFetchItemsCalled_ThenExpectingToSeeError() throws {
        mockServiceProvider.isReturnFailure = true
        
        // When function called
        sut.fetchItems(type: GOTServices.houses.rawValue) { result in
            switch result {
                
            case .success(_):
                XCTFail("Success was not expected")
            
            case .failure(let err):
                XCTAssertEqual(err.localizedDescription, APIError.invalidData.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func test_GivenAppHasFailCharactersResponses_WhenFetchItemsCalled_ThenExpectingToSeeError() throws {
        mockServiceProvider.isReturnFailure = true
        
        // When function called
        sut.fetchItems(type: GOTServices.characters.rawValue) { result in
            switch result {
                
            case .success(_):
                XCTFail("Success was not expected")
            
            case .failure(let err):
                XCTAssertEqual(err.localizedDescription, APIError.invalidData.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func test_GivenAppHasSccuessResponsesWithEmptyData_WhenFetchItemsCalled_ThenExpectingToSeeEmptyData() throws {
        
        // When function called
        sut.fetchItems(type: GOTServices.books.rawValue) { result in
            switch result {
                
            case .success(let items):
               
                XCTAssert(items.isEmpty, "Array should be empty")
            
            case .failure(let err):
                XCTFail("Error was not expected: \(err.localizedDescription)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func test_GivenIncorrectParameterGiven_WhenFetchItemsCalled_ThenExpectingToSeeError() throws {
        
        // Avaliable Categories are 1,2,3. For this test case call anoy other then 1,2,3.
        sut.fetchItems(type: 4) { result in
            switch result {
                
            case .success(let items):
               
                XCTFail("Success was not expected")
            
            case .failure(let err):
                // We should expect invalidRequest error
                XCTAssertEqual(err.localizedDescription, APIError.invalidRequest.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
}


private class MockServiceProvider : ServiceProvider<GOTServices> {
    var items : [ItemsModelProtocol]
    var isReturnFailure: Bool
    
    init(_ items: [ItemsModelProtocol], _ isReturnFailure:Bool = false){
        self.items = items
        self.isReturnFailure = isReturnFailure
    }
    
    override func request<U>(service:GOTServices, decodeType: U.Type, completion: @escaping ((ServiceResult<U>) -> Void)) where U: Decodable {
        if isReturnFailure {
            // completion(.failure(.responseUnsuccessful(NSError(domain: "Not Found", code: 404))))
            completion(.failure(.invalidData))
        }else {
            completion(.success(items as! U))
        }
    }
}

