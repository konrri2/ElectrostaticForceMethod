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
        let feedbacksHistory  = FeedbacksHistory(for: "u1")
        let res = feedbacksHistory.readHistoryRows()
        XCTAssertEqual(res.count, 167, "number of rows in user 1 history")
        
        let feeds = feedbacksHistory.readFeedabcksHistory()
        XCTAssertEqual(feeds.count, 166, "number of rows in user 1 history") //minus header row
        XCTAssertEqual(feeds[0].price, 48900, "first feedback price")
        XCTAssertEqual(feeds[0].category, "komputery", "first feedback category")
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: feeds[0].timestamp)
        let month = calendar.component(.month, from: feeds[0].timestamp)
        let day = calendar.component(.day, from: feeds[0].timestamp)
        
        XCTAssertEqual(year, 2011, "first feedback year")
        XCTAssertEqual(month, 3, "first feedback month")
        XCTAssertEqual(day, 1, "first feedback day")
        //TODO test also last element
    }

    func testGridViewModel() {
        let gvm = GridViewModel()
        XCTAssertEqual(gvm.pricesText[4], "16 PLN", "prices text on grid")
    }
    
    func testParser() {
        let feedbacksHistory  = FeedbacksHistory(for: "test")
        let feeds = feedbacksHistory.readFeedabcksHistory()
        
        assertFeed(feeds[0], false, 1)
        assertFeed(feeds[1], true, 2)
        assertFeed(feeds[2], false, 5)
        assertFeed(feeds[3], true, 10)
        assertFeed(feeds[4], false, 20)
        assertFeed(feeds[5], true, 50)
        assertFeed(feeds[6], false, 100)
        assertFeed(feeds[7], true, 200)
    }
    
    private func assertFeed(_ feed: Feedback, _ isPositive: Bool, _ pricePln: Double) {
        XCTAssertEqual(feed.isPositive, isPositive, "Wrong rating for \(feed)")
        XCTAssertEqual(feed.priceInPln, pricePln, "Wrong price for \(feed)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
