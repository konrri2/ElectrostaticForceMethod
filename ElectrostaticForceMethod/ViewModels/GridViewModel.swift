//
//  GridViewModel.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 31/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation
import SpriteKit


infix operator **
func ** (_ base: Double, _ exp: Double) -> Double {
    return pow(base, exp)
}


///draw grid and cordinates
class GridViewModel {
    var pricesText = [String]()
    
    
    init() {
        for i in 0...12 {
            let text = "\(1 << i) PLN"  //1,2,4,8.....
            pricesText.append(text)
        }
    }
}
