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
    let disposeBag = DisposeBag()
    
    static let rectSize = 1500
    static let xAxisHeight = 50
    static let yAxisWidth = 90
    
    ///Nodes
    let backgroundNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: rectSize, height: rectSize))
    let pricesXAxisNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: rectSize, height: xAxisHeight))
    let categoriesYAxisNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: yAxisWidth, height: rectSize))

    override func didMove(to view: SKView) {
        prepareBackground()
        prepareGrid()
        setupGestures()
        
        getFeetbacksRx()
        animateMove()
    }
    
    func animateMove() {
        //TODO start point - center on test charge
        let startPoint = CGPoint(x: GameScene.yAxisWidth, y: GameScene.xAxisHeight)
        self.animatePan(to: startPoint)
        //self.panForTranslation(CGPoint(x: GameScene.yAxisWidth, y: GameScene.xAxisHeight))
    }
    
    func prepareBackground() {
        backgroundNode.fillColor = .gray
        self.addChild(backgroundNode)
    }
    
    fileprivate func prepareGrid() {
        pricesXAxisNode.fillColor = .darkGray
        self.addChild(pricesXAxisNode)
        gridVM.drawPriceLabels(on: pricesXAxisNode)
        
        categoriesYAxisNode.fillColor = .darkGray
        self.addChild(categoriesYAxisNode)
        gridVM.drawCategoriesLabels(on: categoriesYAxisNode)
    }
    
    func getFeetbacksRx() {
        let feedHistory = FeedbacksHistory(for: "u3")
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
//        guard let camera = self.camera else {
//            return
//        }
//        if sender.state == .began {
//            previousCameraScale = camera.xScale
//        }
//        camera.setScale(previousCameraScale * 1 / sender.scale)

        
//        
//        let pinch = SKAction.scale(by: sender.scale, duration: 0.0)
//        backgroundNode.run(pinch)
        
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
}
