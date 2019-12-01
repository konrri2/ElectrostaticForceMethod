//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit




var categoriesSamples = [
  //           "Allegro   Sport i turystyka   Rowery i akcesoria   Rowery   Przełajowe, Gravel",
            "Allegro   Elektronika   Telefony i Akcesoria   Smartfony i telefony komórkowe   Apple   iPhone XS",
            "Allegro   Elektronika   Komputery   Laptopy   Apple",
            "Allegro   Elektronika   Komputery   Laptopy   Dell",
  //          "Allegro   Elektronika   Komputery   Laptopy   HP",
 //           "Allegro   Elektronika   RTV i AGD   AGD wolnostojące   Pralko-suszarki",
            "Allegro   Elektronika   Fotografia   Aparaty cyfrowe   Lustrzanki",
            "Allegro   Dom i Ogród   Meble   Salon   Stoły" //copy to check if it will not repeat
]



class TreeNode: Comparable {
    static func < (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.level < rhs.level
    }
    
    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    weak var parent: TreeNode?
    var children = [TreeNode]()
    
    ///category nam
    let name: String
    
    ///how deep from the root
    let level: Int
    
    ///some names of allegro categories have the same name eg. "other accesories", so we need an id
    let id: Int
    
    init(_ val: String, _ level: Int) {
        self.name = val
        self.level = level
        id = Tree.currentId
        Tree.currentId += 1
        //print("creating: \(category)")
    }
    
    func add(child: TreeNode) {
        children.append(child)
        child.parent = self
    }
    
    func hasChild(named: String) -> Bool {
        for child in self.children {
            if child.name == named {
                return true
            }
        }
        return false
    }
    
    func getChild(named: String) -> TreeNode? {
        for child in self.children {
            if child.name == named {
                return child
            }
        }
        return nil
    }
}


class Tree {
    var root: TreeNode

    static var currentId = 0
    
    init(initialCategories: [String]) {
        root = TreeNode("Allegro", 0)
        
        for str in initialCategories {
            let returnedLeaf = addBranch(categoriesChain: str)
           //print("leaf = \(returnedLeaf)")
        }
    }
    
    init() {
        root = TreeNode("Allegro", 0)
    }
    
    /**
            categoriesChain is in form:  "Allegro   Elektronika   Komputery   Laptopy   Dell"  //with triple spaces between
        - Returns: leaf node
     */
    public func addBranch(categoriesChain: String) -> TreeNode {
       let chain = categoriesChain.components(separatedBy: "   ")
       guard chain.count > 1 else {
           fatalError("empty categories chain")
       }
       
       return addBranch(jointNode: root, chain: chain, level: 1)
    }

    /// - Parameter level: = how far from the root we want to add branch
    private func addBranch(jointNode: TreeNode, chain: [String], level: Int) -> TreeNode{
        guard level < chain.count else {
            return jointNode //stop recursion
        }
        let cateegoryToAdd = chain[level]
        
        if let childOnTheSameChain = jointNode.getChild(named: cateegoryToAdd) {
            //go deeper into the tree
            return addBranch(jointNode: childOnTheSameChain, chain: chain, level: level+1)
        }
        else {
            //the child node didn't exist before
            let newChildNode = TreeNode(cateegoryToAdd, jointNode.level+1)
            jointNode.add(child: newChildNode)
            return addBranch(jointNode: newChildNode, chain: chain, level: level+1)
        }
    }
    
    static func distance(_ node1: TreeNode?, _ node2: TreeNode?) -> Int {
        guard let n1 = node1, let n2 = node2 else {
            return -1000  //this should never happend, because all brances meet at root
        }
        
        if n1.level == n2.level {
            if n1 == n2 {
                return 0
            }
            else {
                return 1 + Tree.distance(n1.parent, n2)  //one step up
            }
        }
        else if n1.level > n2.level {  //node1 is deeper -> go to parent
            return 1 + Tree.distance(n1.parent, n2)
        }
        else {
            return 1 + Tree.distance(n1, n2.parent)
        }
    }
    
    //TODO:  search  distance(node1,node2)
}

extension TreeNode: CustomStringConvertible {
    var description: String {
        var text = "\(level):\(name)"
        
        if false == children.isEmpty {
            text += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
        }
        return text
    }
}

func makeButton(treeNode: TreeNode, rect: CGRect) -> SKSpriteNode {
    var label: SKLabelNode
    
    
    let zPosition = CGFloat(treeNode.level*2)
    
    let button = SKSpriteNode(imageNamed: "HalfTriangle")
    button.position = CGPoint(x: rect.midX, y: rect.midY)
    button.size = rect.size
    button.name = treeNode.name
    button.zPosition = zPosition
    
    label = SKLabelNode(fontNamed: "Arial")
    label.fontSize = 12
    label.name = "label:\(treeNode.name)"
    label.text = treeNode.name
    label.zPosition = zPosition + 1
    //label.position = CGPoint(x: -(rect.width/3), y: 0)  //force move to the left

    label.zRotation = CGFloat.pi / 3
    button.addChild(label)
    
    logCoordinates(label)
    logCoordinates(button)
    return button
}

func logCoordinates(_ node: SKNode) {
    print("\(node.name ?? "nil") frame = \(node.frame) position=\(node.position)  ")
}

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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func drawBranch(node: TreeNode, frame: CGRect) {
        let rect = frame
        let button = makeButton(treeNode: node, rect: rect)
        scene?.addChild(button)
        if node.level >= 2 {
            return  //don't draw to deap
        }
        else if node.children.count <= 0  {
            return //leaf
        }
        else {
            let childCount = CGFloat(node.children.count)
            let segmentHeight = rect.height / childCount
            let xOffset = rect.width / 4
            var y = rect.origin.y
            let x = rect.origin.x + xOffset
            for ch in node.children {
                let childRect = CGRect(x: x, y: y, width: rect.width - xOffset, height: segmentHeight)
                drawBranch(node: ch, frame: childRect)
                y += segmentHeight
                
                drawLine(fromX: rect.midX, fromY: rect.midY, toX: childRect.midX, toY: childRect.midY)
            }
        }
    }
    
    private func drawLine(fromX: CGFloat, fromY: CGFloat, toX: CGFloat, toY: CGFloat) {
        let yourline = SKShapeNode()
        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: fromX, y: fromY))
        pathToDraw.addLine(to: CGPoint(x: toX, y: toY))
        yourline.path = pathToDraw
        yourline.strokeColor = SKColor.red
        addChild(yourline)
    }
}

// Load the SKScene from 'GameScene.sks'
let frame = CGRect(x:0 , y:0, width: 640, height: 480)
let sceneView = SKView(frame: frame)
 let scene = GameScene(size: frame.size)
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    logCoordinates(scene)
    
    let tree = Tree(initialCategories: categoriesSamples)
    
scene.drawBranch(node: tree.root, frame: scene.frame)
    
    // Present the scene
    sceneView.presentScene(scene)


PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
