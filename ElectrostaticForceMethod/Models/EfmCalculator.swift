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

struct EfmCalculator {
    let disposeBag = DisposeBag()
    
    var resultValue: Double = 0.0
    
    public func subscribe(relay: BehaviorRelay<Feedback>) {
        relay.subscribe(onNext: { (feed) in
            print("next: \(feed)")
        }).disposed(by: disposeBag)
    }
    
    
}
