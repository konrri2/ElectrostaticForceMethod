//
//  Feedback
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 30/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation


struct Feedback {
   
    var isPositive = true
    var timestamp: Date = Date.init(timeIntervalSince1970: 0)
    ///price in polish grosze
    var price = 0
    var category = "unknown"
    
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
        if columns[0].starts(with: "Pos") {
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
        
        self.category = columns[3]
    }
    
}
