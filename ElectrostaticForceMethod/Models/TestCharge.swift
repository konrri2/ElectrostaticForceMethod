//
//  TestCharge.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 20/10/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation


//test charge is just another feedback
struct Deprecated__TestCharge {
    
    
    var price: Double = 0
    var category: String = ""
    
    var problem: String = ""
    
    public func convertToFeedback() -> Feedback {
        var f = Feedback()
        
        f.isPositive = false
        f.price = Int(self.price*100)
        f.category = Category(category)
        
        return f
    }
}
