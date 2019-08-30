//
//  ElectrostaticForceMethodTests.swift
//  ElectrostaticForceMethodTests
//
//  Created by Konrad Leszczyński on 28/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import XCTest
@testable import ElectrostaticForceMethod

class ElectrostaticForceMethodTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCsvReader() {
        let feedbacksHistory  = FeedbacksHistory()
        let res = feedbacksHistory.readHistoryRows(forUser: "u1")
        XCTAssertEqual(res.count, 167, "number of rows in user 1 history")
        
        let feeds = feedbacksHistory.readFeedabcksHistory(for: "u1")
        XCTAssertEqual(feeds.count, 166, "number of rows in user 1 history") //minus header row
        XCTAssertEqual(feeds[0].price, 48900, "first feedback price")
        XCTAssertEqual(feeds[0].category, "komputery", "first feedback category")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
