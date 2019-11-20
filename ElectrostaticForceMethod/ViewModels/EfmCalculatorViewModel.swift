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

struct EfmCalculatorViewModel {
    var theCalculator: EfmCalculator?
    
    init(relay: BehaviorRelay<Feedback>) {
        self.theCalculator = EfmCalculator()
        theCalculator?.subscribe(relay: relay)
    }
}
