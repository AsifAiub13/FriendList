//
//  FriendListTests.swift
//  FriendListTests
//
//  Created by Asif on 10/28/21.
//

import XCTest
@testable import FriendList

class FriendListTests: XCTestCase {

    let friendListAPIExpectation = XCTestExpectation(description: "Check FriendList API")
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFriendListAPIcall() {
        APIManager.shared.getFriends(ofFilter:.All) { success, error, responseValue in
            XCTAssertTrue(success, "API is not giving any response!")
            self.friendListAPIExpectation.fulfill()
        }
        wait(for: [friendListAPIExpectation], timeout: 30.0)
    }

}
