//
//  MenuViewModel.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 29/10/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import SpriteKit

struct MenuViewModel {
    public static var OpenMenuButtonName = "openMenuButton"
    
    var openMenuButton: SKLabelNode
    
    init() {
        openMenuButton = SKLabelNode(fontNamed: "Arial")
        openMenuButton.text = "Menu"
        openMenuButton.name = MenuViewModel.OpenMenuButtonName
    }
    
    public func drawMenu(on bgNode: SKNode) {
//        let label = SKLabelNode(fontNamed: "Arial")
//
//         label.text = "Cccc"
//         label.fontColor = .black
//         label.verticalAlignmentMode = .center
//         label.fontSize = 29.0
//         label.zPosition = 1
//        bgNode.addChild(label)
        openMenuButton.fontSize = 20
        openMenuButton.fontColor = .black
        bgNode.addChild(openMenuButton)
    }
}
