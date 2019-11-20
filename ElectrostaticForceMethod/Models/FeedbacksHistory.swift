//
//  TransactionsHistory.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 30/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

///This history feedback are read from saved files
class FeedbacksHistory {
    
    var feedbacks: [Feedback]
    var userName: String
    let feedbackRelay: BehaviorRelay<Feedback> = BehaviorRelay(value: Feedback())

    
    init(for user: String) {
        userName = user
        feedbacks = [Feedback]()
    }
    

    public func readCsvFeedbacks1by1()  {
        logVerbose("downloading feedbacks from .csv file")

        DispatchQueue.global(qos: .background).async {
             
             let rowsAsStrings = self.readHistoryRows()
             for r in rowsAsStrings {
                 if let t = Feedback(fromCsvRowString: r) {  //first row is a header, last is an empty line - so better check
                    //sleep(2) debug test
                    self.feedbackRelay.accept(t)
                 }
             }
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

    internal func readHistoryRows() -> [String] {
        if let data = readDataFromCSV(fileName: userName) {
            let csvRows = data.components(separatedBy: "\n")
            return csvRows
        }
        else {
            return [String]()
        }
    }
    
    //MARK: - internal method for tests  /////////////////////////////       for test  /////////////////////////////
/*
    internal func readFeedabcksHistory() -> [Feedback] {
       // DispatchQueue.global(qos: .background).async {
            
            let rowsAsStrings = self.readHistoryRows()
            for r in rowsAsStrings {
                if let t = Feedback(fromCsvRowString: r) {  //first row is a header, last is an empty line - so better check
                    logVerbose("appending \(t)")
                    //sleep(1)  //!!! debug test
                    self.feedbacks.append(t)
                }
            }
        //}
        return self.feedbacks
    }
    */
}
