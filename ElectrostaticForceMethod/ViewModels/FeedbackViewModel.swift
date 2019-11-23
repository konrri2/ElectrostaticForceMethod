//
//  FeedbackViewModel.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 16/10/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import SpriteKit

struct FeedbackViewModel {
    var theFeedback: Feedback?
    static let nodeName = "emitter"
    
    //emeral greenish rgb(46, 204, 113)
    let positiveColorSequence = SKKeyframeSequence(
        keyframeValues: [SKColor.green, SKColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)],
                                    times: [0, 1])
    let negativeColorSequence = SKKeyframeSequence(
                                    keyframeValues: [SKColor.yellow, SKColor.red, SKColor.orange],
                                    times: [0, 0.1, 1])
    
    let testChargeColorSequence = SKKeyframeSequence(
                                    keyframeValues: [SKColor.purple, SKColor.white, SKColor.orange],
                                    times: [0, 0.1, 1])
    
    init(_ f: Feedback) {
        self.theFeedback = f
    }
    
    public func draw(on bgNode: SKNode) {
        if let f = theFeedback {
            let pricePosition = log2(f.priceInPln)
            let catPos = Double(f.category.position)
            
            let position = CGPoint(x: pricePosition * priceAxisScale, y: catPos * priceAxisScale)
            
            let emitterNode = SKEmitterNode(fileNamed: "Particle.sks")
            if let emitter = emitterNode {
                emitter.name = FeedbackViewModel.nodeName
                if f.isPositive {
                    emitter.particleAlphaSequence = nil
                    emitter.particleColorSequence = positiveColorSequence
                    emitter.zPosition = Layers.positiveFeedbacks
                }
                else {
                    if f.type == .testCharge {
                        emitter.particleColorSequence = testChargeColorSequence
                        emitter.zPosition = Layers.testChargeFeedbacks
                    }
                    else {
                        emitter.particleColorSequence = negativeColorSequence
                        emitter.zPosition = Layers.negativeFeedbacks
                    }
                }
                emitter.position = position
                bgNode.addChild(emitter)
            } else {
                fatalError("Particle.sks cannot be loaded")
            }
        }
    }
    
    private func randomizePosition(_ center: Double = 50.0) -> Double {
        let random = Double.random(in: -10 ... 10)
        return center + random
    }
}
