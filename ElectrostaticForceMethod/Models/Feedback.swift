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
    
    init() {
        
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
    
    public func priceDistance(to feed2: Feedback) -> Double {
        let dist = self.pricePosition - feed2.pricePosition
        return dist.magnitude
    }
}


