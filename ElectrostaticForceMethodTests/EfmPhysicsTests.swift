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
        
        // log(price) : force //see table 1
        let expectetResults: [Int:Double] = [1:1.960, 2:2.179, 4:1.772, 6:1.414, 8:1.772, 10:2.179, 11:1.960]
        
        for i in 1...15 {
            if let force = expectetResults[i] {
                let qt = Feedback(isPositive: false, price: 1 << i, type: .testCharge)
                let f1 = qt.force(q: q1)
                let f2 = qt.force(q: q2)
                let sumForces = f1+f2
                log("force for qt_\(i)=\(sumForces)")
                XCTAssertEqual(sumForces, force, accuracy: 0.001, "in section 4.1 is in the table 1")
            }
        }
    }
    
    ///figure 3.b is in section 4.1 of the article
    func testForFigure3b() {
        let q1 = Feedback(isPositive: true, price: 1 << 2)
        let q2 = Feedback(isPositive: false, price: 1 << 10)
        
        // log(price) : force //see table 1
        let expectetResults: [Int:Double] = [1:1.692, 2:1.821, 4:1.090, 6:0.0, 8:-1.090, 10:-1.821, 11:-1.692]
        
        for i in 1...15 {
            if let force = expectetResults[i] {
                let qt = Feedback(isPositive: false, price: 1 << i, type: .testCharge)
                let f1 = qt.force(q: q1)
                let f2 = qt.force(q: q2)
                let sumForces = f1+f2
                log("force for qt_\(i)=\(sumForces)")
                XCTAssertEqual(sumForces, force, accuracy: 0.001, "in section 4.1 is in the table 1")
            }
        }
    }
}
