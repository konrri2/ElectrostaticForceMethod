//
//  MenuViewModel.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 29/10/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import SpriteKit

struct MenuViewModel {
    ///names
    public static var OpenMenuButtonName = "openMenuButton"
    
    ///buttons
    var openMenuButton: SKLabelNode
    
    ///the upper right corner where the menu is located
    let corner: CGPoint
    let buttonSize = CGPoint(x:100, y:30)
    let fullMenuSize = CGPoint(x:150, y:250)
    
    var isFolded: Bool = true
    
    var backgroundSprite: SKSpriteNode?
    
    init(corner: CGPoint) {
        self.corner = corner
        openMenuButton = SKLabelNode(fontNamed: "Arial")
        openMenuButton.text = "Menu"
        openMenuButton.name = MenuViewModel.OpenMenuButtonName
        let bgNode = SKSpriteNode(color: .green, size: CGSize(width: fullMenuSize.x, height: fullMenuSize.y))
        self.backgroundSprite = bgNode
    }
    
    public func drawMenu() -> SKSpriteNode? {
        guard let bgNode = self.backgroundSprite else {
            return nil
        }
        bgNode.anchorPoint = CGPoint.zero //CGPoint(x:1, y:1)
        bgNode.position = corner - buttonSize
        //bgNode.position.y = corner.y - 20 //TODO not hardcoded
        
//        let label = SKLabelNode(fontNamed: "Arial")
//
//         label.text = "Cccc"
//         label.fontColor = .black
//         label.verticalAlignmentMode = .center
//         label.fontSize = 29.0
//         label.zPosition = 1
//        bgNode.addChild(label)
        //openMenuButton.fontSize = 20
       // openMenuButton.zPosition = 100
        //openMenuButton.fontColor = .red
        openMenuButton.horizontalAlignmentMode = .left
        openMenuButton.verticalAlignmentMode = .bottom
        //openMenuButton.position.y =
        bgNode.addChild(openMenuButton)
        log("--------- openMenuButton.position= \(openMenuButton.position)")
        
        
        return bgNode
    }
    
    mutating func openMenu() {
        guard let bgNode = self.backgroundSprite else {
            return
        }
        
        if isFolded {
            log("opennig menu")
            let distance = CGPoint.zero - (fullMenuSize - buttonSize)  //one button is already visible
            let moveAction = SKAction.moveBy(x: distance.x, y: distance.y, duration: 1.0)
            bgNode.run(moveAction)
            isFolded = false
            openMenuButton.text = "Hide menu"
        }
        else {
            log("hiding menu")
            let distance = (fullMenuSize - buttonSize)  //one button remains visible
            let moveAction = SKAction.moveBy(x: distance.x, y: distance.y, duration: 1.0)
            bgNode.run(moveAction)
            isFolded = true
            openMenuButton.text = "Menu"
        }
    }
}
