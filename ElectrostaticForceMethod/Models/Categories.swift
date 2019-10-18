//
//  Categories.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 18/10/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation

enum CategoryType: String {
    case computers = "komputery"
    case rtv = "rtv-i-agd"
    case sport = "sport-i-turystyka"
    case photo = "fotografia"
    case phones = "telefony-i-akcesoria"
    
    case unknown = "[unknown]"
}


struct Category {
    var name: String
    var type: CategoryType = .unknown
    
    /// position from point 0,0   not the distance between categories
    var position: Int {
        if let d = CategoriesList.staticPositions[self.type] {
            return d
        }
        else {
            logError("new type of category or what?")
            return 42
        }
    }
    
    init(_ n: String) {
        name = n
        if let t = CategoryType(rawValue: n) {
            self.type = t
        }
        else {
            self.type = CategoryType.unknown
        }
    }
    
    func distance(to c: Category) -> Int {
        fatalError("TODO  implement dynamic category bulding")
    }
}

struct CategoriesList {
    //TODO dynamically build category tree and calculate distances
    
    /// position from point 0,0   not the distance between categories
    static let staticPositions:[CategoryType:Int] = [
        .computers:1,
        .phones:2,
        .rtv:3,
        .photo:4,
        .sport:5,
        .unknown:6
        ]
}
