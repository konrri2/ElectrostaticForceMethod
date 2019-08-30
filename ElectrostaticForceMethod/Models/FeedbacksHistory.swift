//
//  TransactionsHistory.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 30/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation

class FeedbacksHistory {
    
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
    
    internal func readHistoryRows(forUser userName: String) -> [String] {
        if let data = readDataFromCSV(fileName: userName) {
            let csvRows = data.components(separatedBy: "\n")
            return csvRows
        }
        else {
            return [String]()
        }
    }
    
    func readFeedabcksHistory(for userName: String) -> [Feedback] {
        var retTransactions = [Feedback]()
        let rowsAsStrings = readHistoryRows(forUser: userName)
        for r in rowsAsStrings {
            if let t = Feedback(fromCsvRowString: r) {  //first row is a header, last is an empty line - so better check
                retTransactions.append(t)
            }
        }
        return retTransactions
    }
    
}
