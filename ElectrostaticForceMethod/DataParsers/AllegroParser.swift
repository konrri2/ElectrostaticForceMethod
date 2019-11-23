//
//  AllegroParser.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 21/11/2019.
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
    
    //on ffedbacks list pages
    static let feedbackLine = "line"
    
    //fedback up or down <svg class="seller-ratings-list__icon seller-ratings-list__icon--thumb-down"></svg>
    static let thumbIcon = "seller-ratings-list__icon"
    static let thumpUp = "seller-ratings-list__icon--thumb-up"
    static let thumbDown = "seller-ratings-list__icon--thumb-down"
    
    //<a href="https://allegro.pl/oferta/laptop-dell-latitude-e5430-i5-8gb-240gb-ssd-win7-7383979458?snapshot=MjAxOS0wOC0yN1QxNDowNjozNS4yNThaO2J1eWVyOzIzY2E5ZDI5MTkzOTZmMTM3ODhlMTA2ZmVkYjE4N2Q2ZTQ1ODJiYmEwZWZmNDE5MmQyMjcxZTk3N2JkZWZmMGI%3D" class="seller-ratings-list__link seller-ratings-list__link__nga m-link m-link--non-visited long-word-wrap" data-box-name="ItemSnapshot" target="_blank">Laptop DELL Latitude E5430 i5 8GB 240GB SSD WIN7</a>
    static let linkFromFeedbackToItem = "seller-ratings-list__link"
    
    //<a class="_1liky _f81xy _vhk6j _tvw6d _1fm1y" href="https://allegro.pl/kategoria/komputery-stacjonarne-486" itemprop="item" itemtype="http://schema.org/Thing" data-analytics-click-custom-id="486" data-analytics-clickable=""><span itemprop="name">Komputery stacjonarne</span></a>
    static let category = "_1liky _f81xy _vhk6j _tvw6d _1fm1y"
    
    ///url parts
    static let allegroPrefix = "https://allegro.pl"
    //static let aboutSellerUrlPostfix = "#aboutSeller"
    
    
}

struct AllegroParser: DataParser {
    let disposeBag = DisposeBag()
    let outputFeedbacksRelay: BehaviorRelay<Feedback>
    let itemToBuyUrl: URL
    
    init(itemToBuy: String, outputRelay: BehaviorRelay<Feedback>) {
        self.outputFeedbacksRelay = outputRelay
        guard let startlUrl = URL(string: itemToBuy) else {
            fatalError("wrong url format for itemPage= \(itemToBuy)")
        }
        itemToBuyUrl = startlUrl
    }
    
    func readItemToBuy() -> Observable<(Feedback, String)> {
        log("readItemToBuy")
        return Observable.just(itemToBuyUrl)
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)  //it is important not to cache - because it thiks API is a static file. I check isUpToDate() when navigating and changing every second
                return URLSession.shared.rx.data(request: request)
            }.map { data -> String in
                let dataStr = String(data: data, encoding: String.Encoding.utf8)
                guard let htmlString = dataStr else { return "" }
                return htmlString
            }.map { htmlString -> (Feedback, String) in
                var testCharge = Feedback()
                var link = ""
                testCharge.isPositive = false
                testCharge.type = FeedbackType.testCharge
                log("readPage")
                do {
                    let doc: Document = try SwiftSoup.parse(htmlString)
                    (testCharge.price, testCharge.category) = try self.parsePageForPriceAndCategory(doc)
                    
                    let linksWithComments = try doc.getElementsByClass(StaticAllegroStrings.commentsClass).array()
                    if linksWithComments.count >= 3 {
                        let str0 = try linksWithComments[0].attr("href")
                        let str1 = try linksWithComments[1].attr("href")
                        
                        link = str0.commonPrefix(with: str1)
                        //self.getFeedbacksFromComents(feedsUrl: link)
                    }
                } catch {
                    logError("readPage error = \(error)")
                }
            
                return (testCharge, link)
            }
    }
    
    ///input url - needs to be like  /uzytkownik/35585009/oceny....
    func readFeedbacksList(feedsUrl: String) {
        logVerbose("getFeedbacksFromComents(\(feedsUrl))")
        if let url = URL(string: StaticAllegroStrings.allegroPrefix + feedsUrl) {
            Observable.just(url)
                .flatMap { url -> Observable<Data> in
                    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)  //it is important not to cache - because it thiks API is a static file. I check isUpToDate() when navigating and changing every second
                    return URLSession.shared.rx.data(request: request)
            }.map { data -> String in
                let dataStr = String(data: data, encoding: String.Encoding.utf8)
                guard let htmlString = dataStr else { return "" }
                return htmlString
            }.subscribe(onNext:{
                if let arr = self.parseLinksForFeedbacks($0) {
                    DispatchQueue.global(qos: .background).async {
                        for div in arr {
                            self.parseFeedbackAndAddToRelay(div)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        }
        else {
            logError("cannot build feedbacks url from \(feedsUrl)")
        }
    }
}

//MARK: - private methods
extension AllegroParser {
    private func parsePageForPriceAndCategory(_ doc: Document) throws -> (Int, Category) {
        var price: Int = -1
        var category = Category("error")

        let priceDiv = try doc.getElementsByClass(StaticAllegroStrings.itemPriceClass).first()
        if var priceText = try priceDiv?.text() {
            logVerbose("-------------   priceDiv = \(priceText)")
            priceText = priceText.replacingOccurrences(of: ",", with: ".")
            priceText = priceText.filter("0123456789.".contains)
            if let priceInPln = Double(priceText) {
                price = Int((100.0 * priceInPln))  //100 groszy
            }
            else {
                logError("\(priceText) is not a valid price")
            }
        }
        else {
            logError("cannot parse price ")
        }
        
        //TODO parse categories full tree
        if let categoryStr = try doc.getElementsByClass(StaticAllegroStrings.category).first()?.text() {
           category = Category(categoryStr)
        }
        else {
            logError("cannot parse category ")
        }

        return (price, category)
    }
    
    private func parseLinksForFeedbacks(_ htmlString: String) -> Array<Element>? {
        log("readFeedbacksPage")
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            let linksOfComment = try doc.getElementsByClass(StaticAllegroStrings.feedbackLine).array()
            return linksOfComment
        } catch Exception.Error(let type, let message) {
            logError("readFeedbacksPage error of type \(type) = \(message)")
            return nil
        } catch {
            logError("readFeedbacksPage error = \(error)")
            return nil
        }
    }
    
    ///long operation - run only in background
    private func parseFeedbackAndAddToRelay(_ div: Element) {
        var feed = Feedback()
        feed.isPositive = false
        do {
            let thumbSvg = try div.getElementsByClass(StaticAllegroStrings.thumbIcon)
            if thumbSvg.hasClass(StaticAllegroStrings.thumpUp) {
                feed.isPositive = true
            }
            else if thumbSvg.hasClass(StaticAllegroStrings.thumbDown) {
                feed.isPositive = false
            }
            let itemLink = try div.getElementsByClass(StaticAllegroStrings.linkFromFeedbackToItem)
            let itemUrl = try itemLink.attr("href")
            log("itemUrl = \(itemUrl) isPositeve = \(feed.isPositive)")
            if let url = URL(string: itemUrl) {
                Observable.just(url)
                    .flatMap { url -> Observable<Data> in
                        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)  //it is important not to cache - because it thiks API is a static file. I check isUpToDate() when navigating and changing every second
                        return URLSession.shared.rx.data(request: request)
                }.map { data -> String in
                    let dataStr = String(data: data, encoding: String.Encoding.utf8)
                    guard let htmlString = dataStr else { return "" }
                    return htmlString
                }.subscribe(onNext:{ htmlString in
                    do {
                        let doc: Document = try SwiftSoup.parse(htmlString)
                        (feed.price, feed.category) = try self.parsePageForPriceAndCategory(doc)
                        logRx("\n======  output ralay = \(self.outputFeedbacksRelay)  \n feed.price=\(feed.price)")
                        self.outputFeedbacksRelay.accept(feed)
                    } catch {
                        logError("readPage error = \(error)")
                    }
                }).disposed(by: disposeBag)
            }
        } catch {
            logError("parseDivWithFeedback error = \(error)")
        }
    }
}
