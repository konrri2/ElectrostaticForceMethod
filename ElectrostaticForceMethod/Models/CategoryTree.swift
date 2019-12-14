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

