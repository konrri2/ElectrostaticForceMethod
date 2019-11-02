//
//  GameScene.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 28/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import SpriteKit
import GameplayKit
import RxSwift
import RxCocoa

class GameScene: SKScene {
 
    private var gridVM = GridViewModel()
    private var menuVM: MenuViewModel
    let disposeBag = DisposeBag()
    
    ///Dimensions
    let rectSize = 1500
    let xAxisHeight = 50
    let yAxisWidth = 90
    let rightEdge: CGFloat
    let upperEdge: CGFloat
    
    ///Nodes
    let backgroundNode: SKShapeNode
    let pricesXAxisNode: SKShapeNode
    let categoriesYAxisNode: SKShapeNode
   // weak var menuBacgroundNode: SKSpriteNode?
    
    override init(size: CGSize) {
        rightEdge = size.width
        upperEdge = size.height
        backgroundNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: rectSize, height: rectSize))
        pricesXAxisNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: rectSize, height: xAxisHeight))
        categoriesYAxisNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: yAxisWidth, height: rectSize))
        
        menuVM = MenuViewModel(corner: CGPoint(x: rightEdge, y: upperEdge))
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        log("deinit GameScene")
    }
    
    override func didMove(to view: SKView) {
        prepareBackground()
        prepareGrid()
        prepareMenu()
        setupGestures()

        
        getFeetbacksRx(forUser: "u2")
        animateMove()
    }
    
    func animateMove() {
        //TODO start point - center on test charge
        let startPoint = CGPoint(x: yAxisWidth, y: xAxisHeight)
        self.animatePan(to: startPoint)
        //self.panForTranslation(CGPoint(x: GameScene.yAxisWidth, y: GameScene.xAxisHeight))
    }
    
    func prepareBackground() {
        backgroundNode.fillColor = .gray
        backgroundNode.name = "backgroundNode"
        self.addChild(backgroundNode)
    }
    
    fileprivate func prepareGrid() {
        pricesXAxisNode.fillColor = .darkGray
        pricesXAxisNode.name = "pricesXAxisNode"
        self.addChild(pricesXAxisNode)
        gridVM.drawPriceLabels(on: pricesXAxisNode)
        
        categoriesYAxisNode.fillColor = .darkGray
        categoriesYAxisNode.name = "categoriesYAxisNode"
        self.addChild(categoriesYAxisNode)
        gridVM.drawCategoriesLabels(on: categoriesYAxisNode)
    }
    
    func getFeetbacksRx(forUser: String) {
        backgroundNode.removeAllChildren()
        let feedHistory = FeedbacksHistory(for: forUser)
        feedHistory.feedbackRelay
            .subscribe { event in
                if let f = event.element {
                    let fVM = FeedbackViewModel(f)
                    fVM.draw(on: self.backgroundNode)
                }
        }.disposed(by: disposeBag)
        
        feedHistory.downloadFeedbacks1by1()
    }
    
    fileprivate func setupGestures() {
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
        view?.addGestureRecognizer(pinchGesture)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func animatePan(to p: CGPoint, time: Double = 2.0) {
        let bgMove = SKAction.move(to: p, duration: time)
        let xAxisMove = SKAction.moveTo(x: p.x, duration: time)
        let yAxisMove = SKAction.moveTo(y: p.y, duration: time)
        
        backgroundNode.run(bgMove)
        pricesXAxisNode.run(xAxisMove)
        categoriesYAxisNode.run(yAxisMove)
    }
}
    

//MARK: - touches and gesture handling
extension GameScene {
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        backgroundNode.xScale = backgroundNode.xScale * sender.scale
        backgroundNode.yScale = backgroundNode.yScale * sender.scale
        
        pricesXAxisNode.xScale = pricesXAxisNode.xScale * sender.scale
        categoriesYAxisNode.yScale = categoriesYAxisNode.yScale * sender.scale
        
        sender.scale = 1.0
    }
   
    private func panForTranslation(_ translation: CGPoint) {
        let position = backgroundNode.position
        let newX = position.x + translation.x
        let newY = position.y + translation.y
        let aNewPosition = CGPoint(x: newX, y: newY)
        backgroundNode.position = aNewPosition //self.boundLayerPos(aNewPosition)
        
        self.pricesXAxisNode.position =  CGPoint(x: newX, y: 0)
        self.categoriesYAxisNode.position = CGPoint(x: 0, y: newY)
    }

   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       guard let touch = touches.first else { return }
       let positionInScene = touch.location(in: self)
       let previousPosition = touch.previousLocation(in: self)
       let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
       
       panForTranslation(translation)
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let buttonName = touchedNode.name {
                logVerbose("touchedNode.name buttonName= \(buttonName)")
                menuVM.handleClick(buttonName: buttonName)
            }
        }
    }
}

//MARK: - Menus
extension GameScene {
    func prepareMenu() {
        menuVM.gameSceneDelegate = self
        if let menuNode = menuVM.drawMenu() {
            menuNode.name = "menuNode"
            menuNode.zPosition = Layers.menuBacground
        
            self.addChild(menuNode)
        }
    }
}
