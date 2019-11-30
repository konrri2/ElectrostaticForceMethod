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
    
    func drawNode(on parent: SKNode) {
        let label = SKLabelNode(text: "test")
        label.name = "testLabel"
        parent.addChild(label)
        logCoordinates(label)
        logCoordinates(parent)
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
    scene.drawNode(on: scene)
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
