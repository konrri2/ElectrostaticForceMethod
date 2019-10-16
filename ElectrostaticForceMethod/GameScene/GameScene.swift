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
    private var grid = GridViewModel()
    let cameraNode = SKCameraNode()
    let disposeBag = DisposeBag()
    
    override func didMove(to view: SKView) {
        prepareGrid()
        prepareCamera()
        setupGestures()
        
        getFeetbacksRx()
        
        centerCamera(on: CGPoint(x: 100, y: 100))
    }
    
    func getFeetbacksRx() {
        let feedHistory = FeedbacksHistory(for: "u2")
        feedHistory.feedbackRelay
            .subscribe { event in
                log("event = \(event)")
                if let f = event.element {
                    let fVM = FeedbackViewModel(f)
                    fVM.draw(on: self)
                }
        }.disposed(by: disposeBag)
        
        feedHistory.downloadFeedbacks1by1()
    }
    
    func centerCamera(on point: CGPoint) {
        let moveAction = SKAction.move(to: point, duration: 2.0)
        cameraNode.run(moveAction)
    }
    
    func centerOnNode(node: SKNode) {
        let cameraPositionInScene: CGPoint = node.scene!.convert(node.position, from: self)
        node.parent!.run(SKAction.move(to: CGPoint(x:node.parent!.position.x - cameraPositionInScene.x, y:node.parent!.position.y - cameraPositionInScene.y), duration: 2.0))
        
    }

    fileprivate func prepareGrid() {
        for l in grid.pricesLabels {
            self.addChild(l)
        }
    }
    
    fileprivate func prepareCamera() {
        addChild(cameraNode)
        self.camera = cameraNode
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { 
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        camera?.position.x += previousLocation.x - location.x
        camera?.position.y += previousLocation.y - location.y
    }

}
