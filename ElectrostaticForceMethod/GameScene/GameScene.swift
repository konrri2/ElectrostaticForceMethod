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
 
    private var spinnyNode : SKShapeNode?
    var previousCameraScale = CGFloat()
    private var grid = GridViewModel()
    let cameraNode = SKCameraNode()
    let disposeBag = DisposeBag()
    
    override func didMove(to view: SKView) {
        demoTestDebug()
        prepareGrid()
        prepareCamera()
        setupGestures()
        
        getFeetbacksRx()
    }
    
    func getFeetbacksRx() {
        let feedHistory = FeedbacksHistory(for: "u1")
        feedHistory.feedbackRelay
            .subscribe { event in
                log("event = \(event)")
                if let f = event.element {
                    self.drawFeedback(f)
                }
        }.disposed(by: disposeBag)
        
        feedHistory.downloadFeedbacks1by1()
    }
    
    func getFeetbacks_normalMEthods() {
        let feedHistory = FeedbacksHistory(for: "u2")
        let feeds = feedHistory.readFeedabcksHistory()
        
        for f in feeds {
            drawFeedback(f)
        }
    }
    
    func drawFeedback(_ f: Feedback) {
        let pricePosition = log2(f.priceInPln)

        let position = CGPoint(x: 10, y: pricePosition*40.0)
        let circle = SKShapeNode(circleOfRadius: 10)
        circle.position = position
        circle.fillColor = .green
        circle.strokeColor = .red
        
        logVerbose("adding node at \(position)")
        self.addChild(circle)
    }
    
    fileprivate func demoTestDebug() {
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
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
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        camera?.position.x += previousLocation.x - location.x
        camera?.position.y += previousLocation.y - location.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
