//
//  MenuViewModel.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 29/10/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import SpriteKit

struct ButtonNames {
    static let OpenMenuButtonName = "openMenuButton"
}

class MenuViewModel {
    
    var backgroundSprite: SKSpriteNode?
    
    ///buttons
    var menuLabel: SKLabelNode
    var foldMenuButton: SKSpriteNode
    
    ///the upper right corner where the menu is located
    let corner: CGPoint
    let buttonSize = CGSize(width:100, height:50)
    let fullMenuSize = CGSize(width:150, height:250)
    
    var isFolded: Bool = true
    
    let dictionaryOfFunctions = [
        ButtonNames.OpenMenuButtonName: openMenu,
        "function2": function2
    ]

    func function1() {
        NSLog("function1")
    }

    func function2() {
        NSLog("function2")
    }
    
    init(corner: CGPoint) {
        self.corner = corner
        self.backgroundSprite = SKSpriteNode(color: .green, size: fullMenuSize)
    
        self.foldMenuButton = SKSpriteNode(imageNamed: "Button")
        foldMenuButton.size = buttonSize
        foldMenuButton.name = ButtonNames.OpenMenuButtonName
        
        menuLabel = SKLabelNode(fontNamed: "Arial")
        menuLabel.name = ButtonNames.OpenMenuButtonName //both needs the same name because user may fit button or text
        menuLabel.text = "Menu"
    }
    
    public func drawMenu() -> SKSpriteNode? {
        guard let bgNode = self.backgroundSprite else {
            return nil
        }
        bgNode.anchorPoint = CGPoint.zero
        bgNode.position = corner - buttonSize

        menuLabel.horizontalAlignmentMode = .left
       menuLabel.verticalAlignmentMode = .bottom
//        bgNode.addChild(menuLabel)
        
        
        foldMenuButton.addChild(menuLabel)
        bgNode.addChild(foldMenuButton)
        foldMenuButton.anchorPoint = CGPoint.zero
        return bgNode
    }
    
    public func handleClick(buttonName: String) {
        if let function = dictionaryOfFunctions[buttonName] {
            function(self)()
        }
    }
    
    //MARK: - buttons' actions
    
    private func openMenu() {
        guard let bgNode = self.backgroundSprite else {
            return
        }
        
        if isFolded {
            log("opennig menu")
            let distance = CGPoint.zero - (fullMenuSize - buttonSize)  //one button is already visible
            let moveAction = SKAction.moveBy(x: distance.x, y: distance.y, duration: 1.0)
            bgNode.run(moveAction)
            isFolded = false
            menuLabel.text = "Hide menu"
        }
        else {
            log("hiding menu")
            let distance = (fullMenuSize - buttonSize)  //one button remains visible
            let moveAction = SKAction.moveBy(x: distance.x, y: distance.y, duration: 1.0)
            bgNode.run(moveAction)
            isFolded = true
            menuLabel.text = "Menu"
        }
    }
}
