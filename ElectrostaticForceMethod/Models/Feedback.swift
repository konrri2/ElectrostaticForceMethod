//
//  Feedback
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 30/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation

enum FeedbackType {
    case normal
    case testCharge
    case error
}

struct Feedback: CustomStringConvertible {
   
    var isPositive = true
    var timestamp: Date = Date.init(timeIntervalSince1970: 0)
    ///price in polish grosze
    var price = 0
    var category = Category("unknown")
    var type = FeedbackType.normal
    
    var priceInPln: Double {
        return Double(price) / 100.0
    }
    
    ///position on x-axis   (see section 3.1 of the article)
    var pricePosition: Double {
        return log2(priceInPln)
    }

    public var description: String {
        return "feedback's price=\(price)  category=\(category)"
    }
    
    static func makeRandomFeedback() -> Feedback {
        log("DEBUG - making random feedback")
        var f = Feedback()
        f.timestamp = Date()
        f.price = Int.random(in: 10 ... 4000)
        if Int.random(in: 0 ... 4) == 0 {
            f.isPositive = false
        }
        else {
            f.isPositive = true
        }
        return f
    }
    

}

//MARK: distances of the electrostatic charges (see section 3 of the article)
extension Feedback {
    
    ///Distance on x-axis
    internal func priceDistance(to feed2: Feedback) -> Double {
        let dist = self.pricePosition - feed2.pricePosition
        return dist.magnitude
    }
    
    ///Distance on y-axis
    internal func categoryDistance(to feed2: Feedback) -> Double {
        let d = self.category.distance(to: feed2.category)
        return Double(d)
    }
    
    ///Disntance on z-axis -> this distance is constant (see section4 of the article)
    internal func verticalDistance(to feed2: Feedback) -> Double {
        return 4.0
    }
    
    /// "r" in the formulas in the paper
    public func distance(to feed2: Feedback) -> Double {
        let dx = priceDistance(to: feed2)
        let dy = categoryDistance(to: feed2)
        let dz = verticalDistance(to: feed2)
        
        //Piatagoras
        return (dx*dx + dy*dy + dz*dz).squareRoot()
    }
}

//MARK: EFM force formulas (see section 3 of the article)
extension Feedback {
    public func force(q: Feedback) -> Double {
        let r = distance(to: q)
        let charge = q.isPositive ? 1.0 : -1.0
        return charge / (r*r*r)
    }
}
