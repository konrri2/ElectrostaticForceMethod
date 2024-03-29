//
//  EfmCalculatorViewModel.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 20/11/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SpriteKit

struct EfmCalculatorViewModel {
    var theCalculator: EfmCalculator
    let disposeBag = DisposeBag()
    private unowned var backgroundNode: SKNode
    public var resultNode: SKSpriteNode
    let countLabelNode = SKLabelNode(text: "Count: 0")
    let forceValueLabelNode = SKLabelNode(text: "F_q = 0")
    
    init(_ itemToBuy: String, backgroundNode: SKNode) {
        self.backgroundNode = backgroundNode
        self.resultNode = SKSpriteNode(color: UIColor.init(displayP3Red: 200/255, green: 100/255, blue: 200/255, alpha: 0.5), size: CGSize(width: 200, height: 100)) //TODO find .png background with corenr radious and move it to right

        
        self.theCalculator = EfmCalculator(itemToBuy)
        subscribeToDraw(self.theCalculator.testChargeRelay)
        subscribeToDraw(self.theCalculator.feedbacksRelay)
        
        prepareResultsLayout()

        subscribeToWriteCalculations()
        
        theCalculator.start()
    }
    

    
    private func subscribeToDraw(_ relay: BehaviorRelay<Feedback>) {
        relay.subscribe(onNext:{ f in
            let fVM = FeedbackViewModel(f)
            fVM.draw(on: self.backgroundNode)
        }).disposed(by: disposeBag)
    }
    
    private func prepareResultsLayout() {
        resultNode.zPosition = Layers.resultsBackground
        //resultNode.alpha = 0.5
        
        prepareLabels() 
    }
    
    private func prepareLabels() {
        
        countLabelNode.fontColor = .green
        countLabelNode.fontName = "AvenirNext-Bold"
        countLabelNode.position.x = 0
        countLabelNode.position.y = -20
        countLabelNode.fontSize = 14
        countLabelNode.zPosition = Layers.resultsLabels
        
        forceValueLabelNode.fontColor = .yellow //TODO change color if positive/negative
        forceValueLabelNode.fontName = "AvenirNext-Bold"
        forceValueLabelNode.position.x = 0
        forceValueLabelNode.position.y = 20
        forceValueLabelNode.fontSize = 18
        forceValueLabelNode.zPosition = Layers.resultsLabels
        
        self.resultNode.addChild(countLabelNode)
        self.resultNode.addChild(forceValueLabelNode)
    }
    
    //this happens only onece - because feedbacCount is not a observable
    private func subscribeToWriteCalculations() {
        theCalculator.result
            .subscribe(onNext:{
                self.countLabelNode.text = "Count: \($0.count)"
                self.forceValueLabelNode.text = String(format: "F_q = %.2f", $0.force)
            }).disposed(by: disposeBag)
    }
    
    func clear() {
        log("EfmCalculatorViewModel  clear")
        backgroundNode.removeAllChildren()
        resultNode.removeAllChildren()
    }
    
}
