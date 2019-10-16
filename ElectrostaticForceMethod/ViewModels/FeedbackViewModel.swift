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
    
    init(_ f: Feedback) {
        self.theFeedback = f
    }
    
    public func draw(on bgNode: SKNode) {
        if let f = theFeedback {
            let pricePosition = log2(f.priceInPln)

            let position = CGPoint(x: 10, y: pricePosition * priceAxisScale)
            
            let emitterNode = SKEmitterNode(fileNamed: "Particle.sks")
            if let emitter = emitterNode {
                if f.isPositive {
                    setPositiveColor(emitter)
                    emitter.zPosition = Layers.positiveFeedbacks
                }
                else {
                    emitter.zPosition = Layers.negativeFeedbacks
                }
                emitter.position = position
                bgNode.addChild(emitter)
            } else {
                fatalError("Particle.sks cannot be loaded")
            }
        }
    }
    
    private func setPositiveColor(_ emitter: SKEmitterNode) {
        let colors = [SKColor.red, SKColor.green, SKColor.blue]
        
        emitter.particleColorSequence = nil;
        emitter.particleColorBlendFactor = 1.0;
        emitter.particleColor = .green
    }
}
