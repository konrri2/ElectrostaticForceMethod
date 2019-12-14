//
//  CategoryTree.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 14/12/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation


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
