//
//  EfmCalculator.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 20/11/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct EfmResult {
    var count: Int = 0
    var force: Double = 0.0
}

class EfmCalculator {
    var testCharge: Feedback?
    let feedbacksRelay: BehaviorRelay<Feedback> = BehaviorRelay(value: Feedback())
    let testChargeRelay: BehaviorRelay<Feedback> = BehaviorRelay(value: Feedback())
    let disposeBag = DisposeBag()
    var result: BehaviorRelay<EfmResult> = BehaviorRelay(value: EfmResult())


    private var dataParser: DataParser?
    
    init(_ itemToBuy: String) {
        let urlStr = itemToBuy.replacingOccurrences(of: "efm://", with: "")

        if urlStr.hasPrefix("https://allegro.pl/") {
            self.dataParser = AllegroParser(itemToBuy: urlStr, outputRelay: feedbacksRelay)
        }
        else if urlStr.hasPrefix("ebay") {
            //TODO parse ebay
            logError("!!!   ebay parser not implemented !!!")
        }
        else { //load saved user data from .csv
            self.dataParser = CsvParser(itemToBuy: urlStr, outputRelay: feedbacksRelay)
        }
        
        self.feedbacksRelay
            .subscribe(onNext:{
                var val = self.result.value
                val.count += 1
                val.force += self.calculateElectrostaticForce($0)
                
                self.result.accept(val)
            }
        ).disposed(by: disposeBag)
    }
    
    public func start() {
        dataParser?.readItemToBuy()
            .subscribe(onNext:{ (testCharge, link) in
                logVerbose("for test charge \(testCharge) feddbacks are on \(link)")
                self.testCharge = testCharge
                self.testChargeRelay.accept(testCharge)
                //subscirbe calculation
                self.dataParser?.readFeedbacksList(feedsUrl: link)
            }).disposed(by: disposeBag)
    }
    
    private func calculateElectrostaticForce(_ f: Feedback) -> Double {
        //TODO introduce scaling factors
        if let f = self.testCharge?.force(q: f) {
            return f
        }
        else {
            return 0.0
        }
    }
}
