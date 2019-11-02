//
//  MenuViewModel.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 29/10/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import SpriteKit

struct ButtonNames {
    static let unfoldMenu = "openMenuButton"
    static let foldMenu = "hideMenuButton"
    static let testUser1 = "testUser1"
    
    static let text4button: [String:String] = [
        unfoldMenu: "Menu",
        foldMenu: "Hide menu",
        testUser1: "u1"
    ]
}

class MenuViewModel {
    
    var backgroundSprite: SKSpriteNode?
    
    ///buttons
    var showMenuButton: SKSpriteNode
    var hideMenuButton: SKSpriteNode
    var loadTestUsersButtons = [SKSpriteNode]()
    
    ///the upper right corner where the menu is located
    let corner: CGPoint
    let fullMenuSize = CGSize(width:150, height:250)
    
    var isFolded: Bool = true
    
    public weak var gameSceneDelegate: GameScene?
    
    let dictionaryOfFunctions = [
        ButtonNames.unfoldMenu: openMenu,
        ButtonNames.foldMenu: closeMenu,
        ButtonNames.testUser1: loadTestUser1
    ]

    
    init(corner: CGPoint) {
        self.corner = corner
        self.backgroundSprite = SKSpriteNode(color: .clear, size: fullMenuSize)
    
        self.showMenuButton = MenuViewModel.makeButton(name: ButtonNames.unfoldMenu, position: CGPoint(x:50, y:25), size: CGSize(width:100, height:50))
        self.hideMenuButton = MenuViewModel.makeButton(name: ButtonNames.foldMenu, position: CGPoint(x:75, y:25), size: CGSize(width:150, height:50))
        
        self.loadTestUsersButtons.append(MenuViewModel.makeButton(name: ButtonNames.testUser1, position: CGPoint(x:25, y:125), size: CGSize(width:50, height:50)))
        self.loadTestUsersButtons.append(MenuViewModel.makeButton(name: ButtonNames.testUser1, position: CGPoint(x:75, y:125), size: CGSize(width:50, height:50)))
        self.loadTestUsersButtons.append(MenuViewModel.makeButton(name: ButtonNames.testUser1, position: CGPoint(x:125, y:125), size: CGSize(width:50, height:50)))
    }
    
    deinit {
        log("deinit MenuViewModel")
    }
    
    public func drawMenu() -> SKSpriteNode? {
        guard let bgNode = self.backgroundSprite else {
            return nil
        }
        bgNode.anchorPoint = CGPoint.zero
        bgNode.position = corner - showMenuButton.size

        bgNode.addChild(showMenuButton)
        
        for b in loadTestUsersButtons {
            bgNode.addChild(b)
        }
        
        return bgNode
    }
    
    public func handleClick(buttonName: String) {
        if let function = dictionaryOfFunctions[buttonName] {
            function(self)()
        }
    }
    
    
    static func makeButton(name: String, position: CGPoint, size: CGSize) -> SKSpriteNode {
        var label: SKLabelNode
        
        let button = SKSpriteNode(imageNamed: "Button")
        button.size = size
        button.name = name
        button.zPosition = Layers.menu
        
        label = SKLabelNode(fontNamed: "Arial")
        label.fontSize = 20
        label.name = name //both needs the same name because user may fit button or text
        label.text = ButtonNames.text4button[name]
        label.zPosition = Layers.menuLabels
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        
        button.addChild(label)
        button.position = position
        
        return button
    }
    
    
    //MARK: - buttons' actions
    
    private func openMenu() {
        guard let bgNode = self.backgroundSprite else {
            return
        }
        
        if isFolded {
            log("opennig menu")
            let distance = CGPoint.zero - (fullMenuSize - showMenuButton.size)  //one button is already visible
            let moveAction = SKAction.moveBy(x: distance.x, y: distance.y, duration: 1.0)
            bgNode.run(moveAction)
            isFolded = false
            bgNode.addChild(hideMenuButton)
            showMenuButton.removeFromParent()
        }
        else {
            logError("openning unfolded menu again")
        }
    }
    
    private func closeMenu() {
        guard let bgNode = self.backgroundSprite else {
            return
        }
        
        if isFolded {
            logError("closing folded menu again")
        }
        else {
            log("hiding menu")
            let distance = (fullMenuSize - showMenuButton.size)  //one button remains visible
            let moveAction = SKAction.moveBy(x: distance.x, y: distance.y, duration: 1.0)
            bgNode.run(moveAction)
            isFolded = true
            bgNode.addChild(showMenuButton)
            hideMenuButton.removeFromParent()
        }
    }
    
    private func loadTestUser1() {
        log("-------  loading user 1")
        
        gameSceneDelegate?.getFeetbacksRx(forUser: "u1")
    }

}
