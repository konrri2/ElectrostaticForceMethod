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
    
    ///Creates default feedback
    init() {
        
    }
    
    /**
     Please don't confuse with fullData csv format
     
     Accepted CSV format:
     PosNeg;dateTime;price;category
     Pozytywny;01/03/2011 19:20;48900;komputery
     
        */
    init?(fromCsvRowString strRow: String)  {
        let columns = strRow.components(separatedBy: ";")
        guard columns.count == 4 else {
            return nil
        }
        if columns[0].starts(with: "Po") {   // "Pos" string didn't work because in polish we write Pozytyw with "z"
            self.isPositive = true
        }
        else {
            self.isPositive = false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let date = dateFormatter.date(from: columns[1]) {
            timestamp = date
        } else {
            log("cannot parse date for row '\(strRow)' ")
        }
        
        if let priceInt = Int(columns[2]) {
            self.price = priceInt
        } else {
            log("cannot parse price for row '\(strRow)' ")
            return nil
        }

        self.category = Category(columns[3])
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
