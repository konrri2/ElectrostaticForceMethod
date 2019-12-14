//
//  CategoriesTreeViewModel.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 14/12/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation
import SpriteKit

class CategoriesTreeViewModel {
    
    var bgNode: SKNode
    var tree: Tree
    
    init(bacground: SKNode) {
        bgNode = bacground
        tree = Tree(initialCategories: categoriesSamples)
    }
    
    func drawTree() {
        drawBranch(node: tree.root, frame: bgNode.frame)
    }
    
    private func drawBranch(node: TreeNode, frame: CGRect) {
        let rect = frame
        let button = makeButton(treeNode: node, rect: rect)
        bgNode.addChild(button)
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
        bgNode.addChild(yourline)
    }
    
    func makeButton(treeNode: TreeNode, rect: CGRect) -> SKSpriteNode {
        var label: SKLabelNode
        
        
        let zPosition = CGFloat(treeNode.level*2)
        
        let button = SKSpriteNode(imageNamed: "TransparentHalfCircle")
        button.position = CGPoint(x: rect.midX, y: rect.midY)
        button.size = rect.size
        button.name = treeNode.name
        button.zPosition = zPosition
        
        label = SKLabelNode(fontNamed: "Arial")
        label.fontSize = 12
        label.name = "label:\(treeNode.name)"
        
        if treeNode.name.contains(" ") {// many words in name
            let text = treeNode.name
                    .replacingOccurrences(of: " i ", with: "\n")
                    .replacingOccurrences(of: ", ", with: "\n")
            label.text = text
            label.numberOfLines = 2
        }
        else {
            label.text = treeNode.name
        }
        label.zPosition = zPosition + 1
        
        //label.position = CGPoint(x: -(rect.width/3), y: 0)  //force move to the left

        //label.zRotation = CGFloat.pi / 4
        button.addChild(label)
        
        logCoordinates(label)
        logCoordinates(button)
        return button
    }

    func logCoordinates(_ node: SKNode) {
        logGraphics("\(node.name ?? "nil") frame = \(node.frame) position=\(node.position)  ")
    }
}
