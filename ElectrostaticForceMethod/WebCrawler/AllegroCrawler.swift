//
//  AllegroCrawler.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 20/10/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftSoup

/**
    static names of html classes, urls, etc.  uses in allegro pages
 */
struct StaticAllegroStrings {
    //html classes
    static let itemPriceClass = "_wtiln _bdn9q _9a071_2MEB_"
    //<a class="d3438b7e" href="/uzytkownik/4907209/oceny?recommend=false">  recommend=false for negatives and recommend=true for positives
    static let commentsClass = "d3438b7e"
    
    static let jsonPrefix = "dataLayer="
    
    //url parts
    //static let aboutSellerUrlPostfix = "#aboutSeller"
}

/**
    REST API does not have this methods therefore I"m crawling pages manually
 */
class AllegroCrawler {
    var startItemUrl: URL
    
    init(itemPage: String) {
        guard let startlUrl = URL(string: itemPage) else {
            fatalError("wrong url format for itemPage= \(itemPage)")
        }
        startItemUrl = startlUrl
    }
    
    func getItemPage() -> Observable<TestCharge> {
        let url = self.startItemUrl
        
        return Observable.just(url)
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)  //it is important not to cache - because it thiks API is a static file. I check isUpToDate() when navigating and changing every second
                return URLSession.shared.rx.data(request: request)
            }.map { data -> String in
                let dataStr = String(data: data, encoding: String.Encoding.utf8)
                guard let htmlString = dataStr else { return "" }
                return htmlString
            }.map { htmlString -> TestCharge in
                let res = self.readPage(htmlString)
                return res
        }
    }
    
    private func readPage(_ htmlString: String) -> TestCharge {
        var qt = TestCharge(price: -42.0, category: "error", problem: "could not parse page")
        
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)

            let priceDiv = try doc.getElementsByClass(StaticAllegroStrings.itemPriceClass).first()
            if var priceText = try priceDiv?.text() {
                logVerbose("-------------   priceDiv = \(priceText)")
                priceText = priceText.replacingOccurrences(of: ",", with: ".")
                priceText = priceText.filter("0123456789.".contains)
                if let priceInPln = Double(priceText) {
                    qt.price = priceInPln
                }
                else {
                    logError("\(priceText) is not a valid price")
                }
            }
            else {
                logError("cannot parse price for TestCharge")
            }
            
            let linksWithCommands = try doc.getElementsByClass(StaticAllegroStrings.commentsClass).array()
            logVerbose("linksWithCommands.count = \(linksWithCommands.count)")
            
            
            for item in try doc.select("script") {
                let script = try item.html()
                if script.hasPrefix(StaticAllegroStrings.jsonPrefix) {
                    logVerbose("---script with dataLayer  Json----")
                    let json = script.deletingPrefix(StaticAllegroStrings.jsonPrefix)
                    
                    logVerbose(json)
                    
                }
            }
            
        } catch Exception.Error(let type, let message) {
            logError("readPage error of type \(type) = \(message)")
            qt.problem = message
        } catch {
            logError("readPage error = \(error)")
            qt.problem = error.localizedDescription
        }
        
        
        return qt
    }
}


extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
