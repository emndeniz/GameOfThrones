//
//  BooksServiceTest.swift
//  GameOfThronesTests
//
//  Created by Emin on 8.09.2022.
//

import Foundation

import XCTest
@testable import GameOfThrones

class BooksServiceTest: XCTestCase {

    var serviceProvider: ServiceProvider<GOTServices>!
    var expectation: XCTestExpectation!
    
    let apiURL = URL(string: "https://private-anon-232194f887-androidtestmobgen.apiary-mock.com/list/1?")!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        serviceProvider = ServiceProvider<GOTServices>(urlSession:urlSession)
        expectation = expectation(description: "Expectation")
    }
    

    func test_givenBooksRequest_whenResponseSuccessFull_thenShouldContainRquiredData() throws {
        
        // Given
        let data = JSONReader().readLocalFile(forName: "BooksSuccessResponse")
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.apiURL else {
            throw fatalError("URLS are not matching")
          }
          
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        
        // When
        serviceProvider.request(service: .books, decodeType: BooksResponse.self) { result in
            switch result {
                
                //Then
                case .success(let response):
                
                XCTAssert(response.count > 0,"Response array should'nt be empty")
                
                    let firstData:BooksResponseElement = response[0]
                XCTAssertEqual(firstData.name, "A Game of Thrones", "Name is incorrect")
                XCTAssertEqual(firstData.isbn, "978-0553103540", "ISBN is incorrect")
                XCTAssertEqual(firstData.authors, ["George R. R. Martin"], "Authors are incorrect")
                XCTAssertEqual(firstData.numberOfPages, 694, "Number of pages are incorrect")
                XCTAssertEqual(firstData.publisher, "Bantam Books", "Publisher is incorrect")
                XCTAssertEqual(firstData.country, "United States", "Country is incorrect")
                XCTAssertEqual(firstData.mediaType, "Hardcover", "Media type is incorrect")
                XCTAssertEqual(firstData.released, "1996-08-01T00:00:00", "Release date is incorrect")
                
                case .failure(let error):
                    XCTFail("Error was not expected: \(error.localizedDescription)")
                case .empty:
                    XCTFail("Empty case not expecting")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
    }

    
    /// Checking Fail case data retrieve from Categories request
    func test_givenBooksRequest_whenResponseFails_thenShouldReturnFail() throws {

        // For error case we can use empty data
        let data = Data()
        
        MockURLProtocol.requestHandler = { request in
          
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        serviceProvider.request(service: .books, decodeType: BooksResponse.self) { result in
            switch result {
            case .success(_):
                    XCTFail("Success was not expected")
                case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format." , "Parsing error was expected.")
                  //  XCTFail("Error was not expected: \(error.localizedDescription)")
                case .empty:
                    XCTFail("Empty case not expecting")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    

}
