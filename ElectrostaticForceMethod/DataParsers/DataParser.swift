//
//  DataParser.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 21/11/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol DataParser {
    init(itemToBuy: String, outputRelay: BehaviorRelay<Feedback>)
    
    func readItemToBuy() -> Observable<(Feedback, String)>
    func readFeedbacksList(feedsUrl: String)
}
