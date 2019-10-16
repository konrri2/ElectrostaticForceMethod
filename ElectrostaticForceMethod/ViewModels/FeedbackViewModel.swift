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
                //setPositiveColor(emitter)
                
                if f.isPositive {
                    setPositiveColor(emitter)
                    logVerbose("is positive for \(f)")
                    //emitter.zPosition = Layers.positiveFeedbacks
                }
                else {
                    setNegativeColor(emitter)
                    logVerbose("neg \(f)")
                   // emitter.zPosition = Layers.negativeFeedbacks
                }
                emitter.position = position
                bgNode.addChild(emitter)
            } else {
                fatalError("Particle.sks cannot be loaded")
            }
        }
    }
    
    private func setPositiveColor_sequence(_ emitter: SKEmitterNode) {
        let colorSequence = SKKeyframeSequence(keyframeValues: [SKColor.green,
                                                                SKColor.purple,
                                                                //SKColor.red,
                                                                SKColor.blue],
                                               times: [0, 0.5, 1])
        colorSequence.interpolationMode = .linear
        stride(from: 0, to: 1, by: 0.001).forEach {
            let color = colorSequence.sample(atTime: CGFloat($0)) as! SKColor
        }
        
        emitter.particleColorSequence = colorSequence
    }
    
    private func setPositiveColor(_ emitter: SKEmitterNode) {
        emitter.particleColorSequence = nil
        emitter.particleColor = .green
    }
        
    private func setNegativeColor(_ emitter: SKEmitterNode) {
        emitter.particleColorSequence = nil
        emitter.particleColor = .red
    }
}
