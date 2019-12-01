//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene {
    
    
    override func didMove(to view: SKView) {

    }
    
    @objc static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func drawNode(_ position: CGPoint) {
        if position.x < (scene?.size.width ?? 30000.0)  {  //don't draw oudside the box
            let label = SKLabelNode(text: "test")
            label.position = position
            label.name = "testLabel"
            scene?.addChild(label)
            logCoordinates(label)
//            var y = position.y
//            for i in 0...2 {
//                drawNode(CGPoint(x: position.x + 100.0, y: y))
//                y += 50
//            }
        }
    }
}

func logCoordinates(_ node: SKNode) {
    print("\(node.name) frame = \(node.frame) position=\(node.position)  ")
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    //?? //scene.scaleMode = .aspectFill
    scene.name = "scene node"
    scene.drawNode(CGPoint(x:0, y:0))
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
