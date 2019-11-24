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
    static let testUser1 = "u1"
    static let testUser2 = "u2"
    static let testUser3 = "u3"
    static let linkFromClipboard = "linkFromClipboard"
    static let testLink = "testLink"
    
    static let text4button: [String:String] = [
        unfoldMenu: "Menu",
        foldMenu: "Hide menu",
        testUser1: "u1",
        testUser2: "u2",
        testUser3: "u3",
        linkFromClipboard: "Link from clipboard",
        testLink: "test link"
    ]
}

class MenuViewModel {
    
    var backgroundSprite: SKSpriteNode?
    
    ///buttons
    var showMenuButton: SKSpriteNode
    var hideMenuButton: SKSpriteNode
    var loadTestUsersButtons = [SKSpriteNode]()
    var linkFromClipboardButton: SKSpriteNode
    var testLinkButton: SKSpriteNode
    
    ///the upper right corner where the menu is located
    let corner: CGPoint
    let fullMenuSize = CGSize(width:150, height:250)
    
    var isFolded: Bool = true
    
    public unowned var gameSceneDelegate: GameScene
    
    let dictionaryOfFunctions = [
        ButtonNames.unfoldMenu: openMenu,
        ButtonNames.foldMenu: closeMenu,
        ButtonNames.testUser1: loadTestUser,
        ButtonNames.testUser2: loadTestUser,
        ButtonNames.testUser3: loadTestUser,
        ButtonNames.linkFromClipboard: loadFromLinkFromClipboard,
        ButtonNames.testLink: loadFromTestLink
    ]

    
    init(corner: CGPoint, gameSceneDelegate: GameScene) {
        self.gameSceneDelegate = gameSceneDelegate
        self.corner = corner - CGPoint(x: 45, y: 0)  //just move in case of notch
        self.backgroundSprite = SKSpriteNode(color: .clear, size: fullMenuSize)
    
        self.showMenuButton = MenuViewModel.makeButton(name: ButtonNames.unfoldMenu, position: CGPoint(x:50, y:25), size: CGSize(width:100, height:50))
        self.hideMenuButton = MenuViewModel.makeButton(name: ButtonNames.foldMenu, position: CGPoint(x:75, y:25), size: CGSize(width:120, height:50))
        
        self.loadTestUsersButtons.append(MenuViewModel.makeButton(name: ButtonNames.testUser1, position: CGPoint(x:25, y:125), size: CGSize(width:50, height:50)))
        self.loadTestUsersButtons.append(MenuViewModel.makeButton(name: ButtonNames.testUser2, position: CGPoint(x:75, y:125), size: CGSize(width:50, height:50)))
        self.loadTestUsersButtons.append(MenuViewModel.makeButton(name: ButtonNames.testUser3, position: CGPoint(x:125, y:125), size: CGSize(width:50, height:50)))
        
        linkFromClipboardButton = MenuViewModel.makeButton(name: ButtonNames.linkFromClipboard, position: CGPoint(x:75, y:75), size: CGSize(width:200, height:50))
        
        testLinkButton = MenuViewModel.makeButton(name: ButtonNames.testLink, position: CGPoint(x:75, y:175), size: CGSize(width:200, height:50))
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
        bgNode.addChild(linkFromClipboardButton)
        bgNode.addChild(testLinkButton)
        for b in loadTestUsersButtons {
            bgNode.addChild(b)
        }
        
        return bgNode
    }
    
    public func handleClick(buttonName: String) {
        if let function = dictionaryOfFunctions[buttonName] {
            function(self)(buttonName)
        }
        if buttonName != ButtonNames.unfoldMenu {  //just hide after choosing an option
            closeMenu(buttonName: "")
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
    func openMenu(buttonName: String) {
        guard let bgNode = self.backgroundSprite else {
            return
        }
        
        if isFolded {
            logGraphics("openig menu")
            let distance = CGPoint.zero - (fullMenuSize - showMenuButton.size)  //one button is already visible
            let moveAction = SKAction.moveBy(x: distance.x, y: distance.y, duration: 0.5)
            bgNode.run(moveAction)
            isFolded = false
            bgNode.addChild(hideMenuButton)
            showMenuButton.removeFromParent()
        }
        else {
            logError("opening unfolded menu again")
        }
    }
    
    private func closeMenu(buttonName: String) {
        guard let bgNode = self.backgroundSprite else {
            return
        }
        
        if isFolded {
            logError("closing folded menu again")
        }
        else {
            logGraphics("hiding menu")
            let distance = (fullMenuSize - showMenuButton.size)  //one button remains visible
            let moveAction = SKAction.moveBy(x: distance.x, y: distance.y, duration: 0.5)
            bgNode.run(moveAction)
            isFolded = true
            bgNode.addChild(showMenuButton)
            hideMenuButton.removeFromParent()
        }
    }
    
    private func loadTestUser(buttonName: String) {
        logVerbose("-------  loading feedbacks for \(buttonName)")

        gameSceneDelegate.loadData(buttonName)
    }
    
    private func loadFromTestLink(buttonName: String) {
        logVerbose("-------  loading feedbacks for \(buttonName)")
        
        gameSceneDelegate.loadData("efm://https://allegro.pl/oferta/kross-esker-2-0-wisniowy-srebrny-m-20-8445656508")
    }
    
    
    //let suiteName = "group.pl.edu.leszczynski.ElectrostaticForceMethod"
    //let urlKey = "urlKey"
    
    
    private func loadFromLinkFromClipboard(buttonName: String) {
        logVerbose("loadFromLinkFromClipboard")
        
        let pasteboardString: String? = UIPasteboard.general.string
        if let theString = pasteboardString {
            print("String is \(theString)")
        }
        
//        let group = UserDefaults(suiteName: suiteName)!
//        if let object = group.object(forKey: urlKey) {
//             log("=======urlString object= \(object)")
//        }
    }

}
