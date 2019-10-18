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
        for i in 1...12 {
            let text = "\(1 << i) \nPLN"  //1,2,4,8.....
            pricesText.append(text)
        }
    }
    
    ///horizontal x axis
    public func drawPriceLabels(on bgNode: SKNode) {
        let yPosition = zeroPoint.y
        var xPosition = distanceBetweenPriceLabels  //we skip the "1 PLN" label
        for t in pricesText {
            let labelNode = SKLabelNode(text: t)
            labelNode.position.x = xPosition
            labelNode.position.y = yPosition
            labelNode.numberOfLines = 2
            labelNode.fontSize = 20
            bgNode.addChild(labelNode)
            xPosition += distanceBetweenPriceLabels
        }
    }
    
    ///vertical y axis
    public func drawCategoriesLabels(on bgNode: SKNode) {
        let xPosition = zeroPoint.x + 10  //20 margin
        for (name, distance) in CategoriesList.staticPositions {
            let txt = name.rawValue
                .replacingOccurrences(of: "-i-", with: "\n")
            let labelNode = SKLabelNode(text: txt)
            labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            labelNode.verticalAlignmentMode = .center
            labelNode.position.x = xPosition
            labelNode.position.y = CGFloat(distance) * distanceBetweenPriceLabels
            labelNode.numberOfLines = 3 //??
            labelNode.fontSize = 16
            bgNode.addChild(labelNode)
        }
    }
}
