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
        f.isPositive = false
        return Observable.just((f, self.feedsFileName))
    }
    
    func readFeedbacksList(feedsUrl: String) {
        DispatchQueue.global(qos: .background).async {
             let rowsAsStrings = self.readHistoryRows()
             for r in rowsAsStrings {
                if let f = self.buildFeedback(fromCsvRowString: r) {  //first row is a header, last is an empty line - so better check
                    self.outputFeedbacksRelay.accept(f)
                }
             }
         }
    }
    
    
}

//MARK: - private methods
extension CsvParser {
    private func readTestCharge() -> String {
        if let data = readDataFromCSV(fileName: feedsFileName, fileType: "csvqt") {
            let csvRows = data.components(separatedBy: "\n")
            return csvRows.first ?? ""
        }
        else {
            return ""
        }
    }
    
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
            logError("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    private func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    /**
        Please don't confuse with fullData csv format
        Accepted CSV format:
        PosNeg;dateTime;price;category
        Pozytywny;01/03/2011 19:20;48900;komputery
           */
    private func buildFeedback(fromCsvRowString strRow: String) -> Feedback? {
        var feed = Feedback()
        let columns = strRow.components(separatedBy: ";")
        guard columns.count == 4 else {
            return nil
        }
        if columns[0] == "PosNeg" { //this is a header
            return nil
        }
        if columns[0].starts(with: "Po") {   // "Pos" string didn't work because in polish we write Pozytyw with "z"
            feed.isPositive = true
        }
        else {
            feed.isPositive = false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let date = dateFormatter.date(from: columns[1]) {
            feed.timestamp = date
        } else {
            log("cannot parse date for row '\(strRow)' ")
        }
        
        if let priceInt = Int(columns[2]) {
            feed.price = priceInt
        } else {
            log("cannot parse price for row '\(strRow)' ")
            return nil
        }

        feed.category = Category(columns[3])
        
        return feed
    }
}
