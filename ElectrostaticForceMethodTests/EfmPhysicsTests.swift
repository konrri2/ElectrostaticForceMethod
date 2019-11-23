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
        var qt = Feedback(isPositive: false, price: 6, type: .testCharge)
        var q1 = Feedback(isPositive: true, price: 2)
        var q2 = Feedback(isPositive: true, price: 10)
        
        var dist1 = qt.distance(to: q1)
        var dist2 = qt.distance(to: q2)
        log("distance 1 = \(dist1);   dist2= \(dist2)")
        XCTAssertNotEqual(dist1, dist2, accuracy: 0.00001, "distances should be for logrithm prices")
        
        
        qt = Feedback(isPositive: false, price: 1 << 6, type: .testCharge)
        q1 = Feedback(isPositive: true, price: 1 << 2)
        q2 = Feedback(isPositive: true, price: 1 << 10)
        
        dist1 = qt.distance(to: q1)
        dist2 = qt.distance(to: q2)
        log("price1 = \(q1.price)    price2 = \(q2.price)")
        log("distance 1 = \(dist1);   dist2= \(dist2)")
        XCTAssertEqual(dist1, dist2, accuracy: 0.00001, "distances should be equal")
        
        let f1 = qt.force(q: q1)
        let f2 = qt.force(q: q2)
        log("f1=\(f1)   f2=\(f2)")
        let sumForces = f1+f2
        XCTAssertEqual(sumForces, 1.414, accuracy: 0.001, "in section 4.1 of the article resulting force is 1.414")
        XCTAssertEqual(f1, f2, accuracy: 0.00001, "forces should be equal")
    }

    ///figure 2.a is in section 4.1 of the article
    func testForFigure2b() {
        let qt = Feedback(isPositive: false, price: 1 << 6, type: .testCharge)
        let q1 = Feedback(isPositive: true, price: 1 << 2)
        let q2 = Feedback(isPositive: false, price: 1 << 10)
        
        let dist1 = qt.distance(to: q1)
        let dist2 = qt.distance(to: q2)
        
        log("price1 = \(q1.price)    price2 = \(q2.price)")
        log("distance 1 = \(dist1);   dist2= \(dist2)")
        XCTAssertEqual(dist1, dist2, accuracy: 0.00001, "distances should be equal")

        let f1 = qt.force(q: q1)
        let f2 = qt.force(q: q2)
        log("f1=\(f1)   f2=\(f2)")
        let sumForces = f1+f2
        XCTAssertEqual(sumForces, 0, accuracy: 0.001, "in section 4.1 of the article resulting force is 0")
        XCTAssertNotEqual(f1, f2, accuracy: 0.00001, "forces cannot be equal")
    }
    
    ///figure 3.a is in section 4.1 of the article
    func testForFigure3a() {
        let q1 = Feedback(isPositive: true, price: 1 << 2)
        let q2 = Feedback(isPositive: true, price: 1 << 10)
        
        var qt = Feedback(isPositive: false, price: 1 << 1, type: .testCharge)
    }
}
