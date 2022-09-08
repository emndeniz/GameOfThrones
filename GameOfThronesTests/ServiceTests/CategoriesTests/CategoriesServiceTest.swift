//
//  CategoriesServiceTest.swift
//  GameOfThronesTests
//
//  Created by Emin on 8.09.2022.
//

import Foundation

import XCTest
@testable import GameOfThrones


class CategoriesServiceTests: XCTestCase {
    
    
    var serviceProvider: ServiceProvider<CategoriesSevice>!
    var expectation: XCTestExpectation!
    
    let apiURL = URL(string: "https://private-anon-232194f887-androidtestmobgen.apiary-mock.com/categories?")!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        serviceProvider = ServiceProvider<CategoriesSevice>(urlSession:urlSession)
        expectation = expectation(description: "Expectation")
    }
    
    
    /// Checking success data retrieve from Categories request
    func test_givenCategoriesRequest_whenResponseSuccessFull_thenShouldContainRquiredData() throws {

        
        let data = JSONReader().readLocalFile(forName: "CategoriesSuccessResponse")
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.apiURL else {
            throw fatalError("URLS are not matching")
          }
          
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        serviceProvider.request(service: .categories, decodeType: CategoriesResponse.self) { result in
            switch result {
                case .success(let response):
                    let books:CategoriesResponseElement = response[0]
                    let houses:CategoriesResponseElement = response[1]
                    let characters:CategoriesResponseElement = response[2]
                
                    // Asseting responses
                    XCTAssertEqual(books.categoryName, "Books","Category nanme is incorrect!")
                    XCTAssertEqual(books.type, 0, "Type is incorrect!")
                    XCTAssertEqual(houses.categoryName, "Houses","Category nanme is incorrect!")
                    XCTAssertEqual(houses.type, 1, "Type is incorrect!")
                    XCTAssertEqual(characters.categoryName, "Characters","Category nanme is incorrect!")
                    XCTAssertEqual(characters.type, 2, "Type is incorrect!")
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
    func test_givenCategoriesRequest_whenResponseFails_thenShouldReturnFail() throws {

        // For error case we can use empty data
        let data = Data()
        
        MockURLProtocol.requestHandler = { request in
          
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        serviceProvider.request(service: .categories, decodeType: CategoriesResponse.self) { result in
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
