//
//  ElectrostaticForceMethodTests.swift
//  ElectrostaticForceMethodTests
//
//  Created by Konrad Leszczyński on 28/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
@testable import ElectrostaticForceMethod

class ElectrostaticForceMethodTests: XCTestCase {

    let outputFeedbacksRelay: BehaviorRelay<Feedback> = BehaviorRelay(value: Feedback())
    var disposeBag: DisposeBag!
    
    override func setUp() {
       disposeBag = DisposeBag()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //TODO  
    
/*
    func testCsvReader() {
        let feedbacksHistory  = CsvParser(itemToBuy: "u1", outputRelay: outputFeedbacksRelay)
        let res = feedbacksHistory.readHistoryRows()
        XCTAssertEqual(res.count, 167, "number of rows in user 1 history")
        
        let feeds = feedbacksHistory.readFeedabcksHistory()
        XCTAssertEqual(feeds.count, 166, "number of rows in user 1 history") //minus header row
        XCTAssertEqual(feeds[0].price, 48900, "first feedback price")
        XCTAssertEqual(feeds[0].category.type, Category("komputery").type, "first feedback category")
            
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
        XCTAssertEqual(gvm.pricesText[4], "32 \nPLN", "prices text on grid")
    }
*/
    func testParser() {
        let sut = CsvParser(itemToBuy: "test", outputRelay: outputFeedbacksRelay)
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
    
    func testAllegroCrawler() {
        let sut = AllegroParser(itemToBuy: "https://allegro.pl/oferta/kross-esker-2-0-wisniowy-srebrny-m-20-8445656508", outputRelay: self.outputFeedbacksRelay)
        //this bike cost 2 789,00 zł
        do {
            let blockinObservable = sut.readItemToBuy()
                .toBlocking()
                //.first()
            
            if let (qt, link) = try blockinObservable.first() {
                XCTAssertNotNil(qt.price)
                XCTAssertGreaterThan(qt.price, 0, "error - negative price")
                log("link = \(link)")
                XCTAssertTrue(link.contains("/oceny"), "link msut contains fragment /oceny ")
                XCTAssertTrue(link.contains("/uzytkownik/"), "link msut contains fragment /uzytkownik/ ")
            }
            else {
                XCTFail("readItemToBuy was nil")
            }
        } catch {
            logError("sut.getItemPage()")
        }
    }

}
