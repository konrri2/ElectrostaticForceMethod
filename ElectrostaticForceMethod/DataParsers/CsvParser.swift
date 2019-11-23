//
//  CsvParser.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 21/11/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CsvParser: DataParser {
    let disposeBag = DisposeBag()
    let outputFeedbacksRelay: BehaviorRelay<Feedback>
    let feedsFileName: String
    
    init(itemToBuy: String, outputRelay: BehaviorRelay<Feedback>) {
        self.feedsFileName = itemToBuy //TODO keep it in json or smthing
        self.outputFeedbacksRelay = outputRelay
    }
    
    func readItemToBuy() -> Observable<(Feedback, String)> {
        //TODO maybe keep it in json
        var f = Feedback.makeRandomFeedback()
        f.type = .testCharge
        return Observable.just((f, self.feedsFileName))
    }
    
    func readFeedbacksList(feedsUrl: String) {
        DispatchQueue.global(qos: .background).async {
             let rowsAsStrings = self.readHistoryRows()
             for r in rowsAsStrings {
                 if let t = Feedback(fromCsvRowString: r) {  //first row is a header, last is an empty line - so better check
                    //sleep(2) debug test
                    self.outputFeedbacksRelay.accept(t)
                 }
             }
         }
    }
    
    
}

//MARK: - private methods
extension CsvParser {
    private func readHistoryRows() -> [String] {
        if let data = readDataFromCSV(fileName: feedsFileName) {
            let csvRows = data.components(separatedBy: "\n")
            return csvRows
        }
        else {
            return [String]()
        }
    }
    
    private func readDataFromCSV(fileName:String, fileType: String = "csv")-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    private func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
}
