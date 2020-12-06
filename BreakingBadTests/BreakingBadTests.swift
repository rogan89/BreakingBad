//
//  BreakingBadTests.swift
//  BreakingBadTests
//
//  Created by Brendan Rogan on 12/4/20.
//

import XCTest
@testable import BreakingBad

class BreakingBadTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetCharactersWebRequest() {
        
        let expectation = XCTestExpectation(description: "Download characters")
        
        BreakingBadAPI.getCharacters { res in
            
            switch res {
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            case .success(let characters):
                XCTAssertNotNil(characters)
            }
        
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

}
