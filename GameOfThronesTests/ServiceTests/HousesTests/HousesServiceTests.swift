//
//  HousesServiceTests.swift
//  GameOfThronesTests
//
//  Created by Emin on 8.09.2022.
//

import Foundation
import XCTest
@testable import GameOfThrones

class HousesServiceTests: XCTestCase {

    var serviceProvider: ServiceProvider<GOTServices>!
    var expectation: XCTestExpectation!
    
    let apiURL = URL(string: "https://private-anon-232194f887-androidtestmobgen.apiary-mock.com/list/2?")!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        serviceProvider = ServiceProvider<GOTServices>(urlSession:urlSession)
        expectation = expectation(description: "Expectation")
    }
    

    func test_givenHousesRequest_whenResponseSuccessFull_thenShouldContainRquiredData() throws {
        
        // Given
        let data = JSONReader().readLocalFile(forName: "HousesSuccessResponse")
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.apiURL else {
            throw fatalError("URLS are not matching")
          }
          
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        
        // When
        serviceProvider.request(service: .houses, decodeType: HousesResponse.self) { result in
            switch result {
                
                //Then
                case .success(let response):
                
                XCTAssert(response.count > 0,"Response array should'nt be empty")
                
                    let firstData:HousesResponseElement = response[0]
                XCTAssertEqual(firstData.name, "House Algood","Name is incorrect")
                XCTAssertEqual(firstData.id, "1", "ID is incorrect")
                XCTAssertEqual(firstData.region, "The Westerlands", "Region is incorrect")
                XCTAssertEqual(firstData.title, "A golden wreath, on a blue field with a gold border(Azure, a garland of laurel within a bordure or)", "Title is incorrect")
              
                case .failure(let error):
                    XCTFail("Error was not expected: \(error.localizedDescription)")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
    }

    
    /// Checking Fail case data retrieve from Categories request
    func test_givenHousesRequest_whenResponseFails_thenShouldReturnFail() throws {

        // For error case we can use empty data
        let data = Data()
        
        MockURLProtocol.requestHandler = { request in
          
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        serviceProvider.request(service: .houses, decodeType: HousesResponse.self) { result in
            switch result {
            case .success(_):
                    XCTFail("Success was not expected")
                case .failure(let error):
                
                XCTAssertEqual(error.localizedDescription, APIError.jsonConversionFailure.localizedDescription)
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    

}
