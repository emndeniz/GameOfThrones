//
//  File.swift
//  GameOfThronesTests
//
//  Created by Emin on 8.09.2022.
//


import Foundation

import XCTest
@testable import GameOfThrones


class CharactersServiceTest: XCTestCase {
    
    
    var serviceProvider: ServiceProvider<GOTServices>!
    var expectation: XCTestExpectation!
    
    let apiURL = URL(string: "https://private-anon-232194f887-androidtestmobgen.apiary-mock.com/list/3?")!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        serviceProvider = ServiceProvider<GOTServices>(urlSession:urlSession)
        expectation = expectation(description: "Expectation")
    }
    

    func test_givenCharactersRequest_whenResponseSuccessFull_thenShouldContainRquiredData() throws {
        
        // Given
        let data = JSONReader().readLocalFile(forName: "CharactersSuccessResponse")
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.apiURL else {
            throw fatalError("URLS are not matching")
          }
          
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        
        // When
        serviceProvider.request(service: .characters, decodeType: CharactersResponse.self) { result in
            switch result {
                
                //Then
                case .success(let response):
                
                XCTAssert(response.count > 0,"Response array should'nt be empty")
                
                    let tywin:CharactersResponseElement = response[3]
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
                
                case .failure(let error):
                    XCTFail("Error was not expected: \(error.localizedDescription)")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
    }

    
    /// Checking Fail case data retrieve from Categories request
    func test_givenCharactersRequest_whenResponseFails_thenShouldReturnFail() throws {

        // For error case we can use empty data
        let data = Data()
        
        MockURLProtocol.requestHandler = { request in
          
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        serviceProvider.request(service: .characters, decodeType: CharactersResponse.self) { result in
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
