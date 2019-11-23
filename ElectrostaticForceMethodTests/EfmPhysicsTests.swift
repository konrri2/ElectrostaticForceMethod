//
//  EfmPhysicsTests.swift
//  ElectrostaticForceMethodTests
//
//  Created by Konrad Leszczyński on 23/11/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import XCTest
@testable import ElectrostaticForceMethod

class EfmPhysicsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    ///figure 2.a is in section 4.1 of the article
    func testForFigure2a() {
        let qt = Feedback(isPositive: false, type: .testCharge, price: 6.0)
        let q1 = Feedback(isPositive: true, price: 2.0)
        let q2 = Feedback(isPositive: true, price: 10.0)
        
        let dist1 = qt.distance(to: q1)
        let dist2 = qt.distance(to: q2)
        log("distance 1 = \(dist1);   dist2=\(dist1)")
        XCTAssertEqual(dist1, dist2, "distances should be equal")
    }


}
