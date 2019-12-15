//
//  Constants.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 16/10/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import SpriteKit

//GLOBAL VARIABLES


///number of points to multiply on price axis
let priceAxisScale = 50.0

///z positions
struct Layers {
    static let tree = CGFloat(-5)
    static let xAxis = CGFloat(0)
    static let background = CGFloat(5)
    
    static let positiveFeedbacks = CGFloat(10)
    static let negativeFeedbacks = CGFloat(20) //show negative above
    static let testChargeFeedbacks = CGFloat(40)
    
    static let menuBacground = CGFloat(28)
    static let menu = CGFloat(30)
    static let menuLabels = CGFloat(32)
    
    static let resultsBackground = CGFloat(40)
    static let resultsLabels = CGFloat(42)
    
}
