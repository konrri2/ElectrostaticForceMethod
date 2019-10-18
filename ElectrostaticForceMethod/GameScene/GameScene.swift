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
 
    var previousCameraScale = CGFloat()
    private var gridVM = GridViewModel()

    let disposeBag = DisposeBag()
    
    ///Nodes
    let cameraNode = SKCameraNode()
    let backgroundNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 1000, height: 1000))
    let pricesXAxisNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 1000, height: 60))
    
    override func didMove(to view: SKView) {
        prepareBackground()
        prepareGrid()
        //prepareCamera()
        setupGestures()
        
        getFeetbacksRx()
        
        //centerCamera(on: CGPoint(x: 100, y: 100))
    }
    
    func prepareBackground() {
        backgroundNode.fillColor = .gray
        self.addChild(backgroundNode)
    }
    
    fileprivate func prepareGrid() {
        pricesXAxisNode.fillColor = .darkGray
        self.addChild(pricesXAxisNode)
        gridVM.drawPriceLabels(on: pricesXAxisNode)
    }
    
    func getFeetbacksRx() {
        let feedHistory = FeedbacksHistory(for: "u1")
        feedHistory.feedbackRelay
            .subscribe { event in
                if let f = event.element {
                    let fVM = FeedbackViewModel(f)
                    fVM.draw(on: self.backgroundNode)
                }
        }.disposed(by: disposeBag)
        
        feedHistory.downloadFeedbacks1by1()
    }
    
   
    
    func centerOnNode(node: SKNode) {
        let cameraPositionInScene: CGPoint = node.scene!.convert(node.position, from: self)
        node.parent!.run(SKAction.move(to: CGPoint(x:node.parent!.position.x - cameraPositionInScene.x, y:node.parent!.position.y - cameraPositionInScene.y), duration: 2.0))
        
    }


    
    fileprivate func prepareCamera() {
        backgroundNode.addChild(cameraNode)
        self.camera = cameraNode
    }
    
    func centerCamera(on point: CGPoint) {
           let moveAction = SKAction.move(to: point, duration: 2.0)
           cameraNode.run(moveAction)
    }
    
    fileprivate func setupGestures() {
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
        view?.addGestureRecognizer(pinchGesture)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
    

//MARK: - touches and gesture handling
extension GameScene {
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        if sender.state == .began {
            previousCameraScale = camera.xScale
        }
        camera.setScale(previousCameraScale * 1 / sender.scale)
    }
   
    private func panForTranslation(_ translation: CGPoint) {
        let position = backgroundNode.position
        let newX = position.x + translation.x
        let newY = position.y + translation.y
        let aNewPosition = CGPoint(x: newX, y: newY)
        backgroundNode.position = aNewPosition //self.boundLayerPos(aNewPosition)
        
        self.pricesXAxisNode.position =  CGPoint(x: newX, y: 0)
    }

   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       guard let touch = touches.first else { return }
       let positionInScene = touch.location(in: self)
       let previousPosition = touch.previousLocation(in: self)
       let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
       
       panForTranslation(translation)
   }
}
