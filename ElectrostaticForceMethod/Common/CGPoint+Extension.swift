//
//  CGPoint+Extension.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 01/11/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import CoreGraphics
import SpriteKit

public extension CGPoint {
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
      return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func += (left: inout CGPoint, right: CGPoint) {
      left = left + right
    }

    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
      return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
      return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
      return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }
    
    //MARK: - CGSize it makes no mathematical sense but it simplifies my code
    static func + (left: CGPoint, right: CGSize) -> CGPoint {
      return CGPoint(x: left.x + right.width, y: left.y + right.height)
    }
    static func - (left: CGPoint, right: CGSize) -> CGPoint {
      return CGPoint(x: left.x - right.width, y: left.y - right.height)
    }
}

public extension CGSize {
    //MARK: - convetting CGSize s to oints -> it makes no mathematical sense but it simplifies my code
    static func + (left: CGSize, right: CGSize) -> CGPoint {
      return CGPoint(x: left.width + right.width, y: left.height + right.height)
    }
    static func - (left: CGSize, right: CGSize) -> CGPoint {
      return CGPoint(x: left.width - right.width, y: left.height - right.height)
    }
    
}
