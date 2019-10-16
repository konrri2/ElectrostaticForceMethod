//
//  GridViewModel.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 31/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation
import SpriteKit




///draw grid and cordinates
class GridViewModel {
    var pricesText = [String]()
    var pricesLabels = [SKLabelNode]()
    
    let zeroPoint = CGPoint(x: 0, y: 0)
    let distanceBetweenPriceLabels = CGFloat(priceAxisScale)
    
    init() {
        for i in 0...12 {
            let text = "\(1 << i) PLN"  //1,2,4,8.....
            pricesText.append(text)
        }
        
        setupLabels()
    }
    
    private func setupLabels() {
        var yPosition = zeroPoint.y
        let xPosition = zeroPoint.x
        for t in pricesText {
            let labelNode = SKLabelNode(text: t)
            labelNode.position.x = xPosition
            labelNode.position.y = yPosition
            pricesLabels.append(labelNode)
            
            yPosition += distanceBetweenPriceLabels
        }
    }
}
