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
    
    let positiveColorSequence = SKKeyframeSequence(keyframeValues: [SKColor.green,
                     SKColor.yellow,
                     SKColor.green,
                     SKColor.blue],
    times: [0, 0.25, 0.5, 1])
    let negativeColorSequence = SKKeyframeSequence(
                                    keyframeValues: [SKColor.yellow, SKColor.red, SKColor.orange],
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
                if f.isPositive {
                    emitter.particleAlphaSequence = nil
                    emitter.particleColorSequence = positiveColorSequence
                    emitter.zPosition = Layers.positiveFeedbacks
                }
                else {
                    emitter.particleColorSequence = negativeColorSequence
                    emitter.zPosition = Layers.negativeFeedbacks
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
