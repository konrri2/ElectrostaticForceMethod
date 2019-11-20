//
//  GameScene.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 28/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import SpriteKit
import GameplayKit
import RxSwift
import RxCocoa

class GameScene: SKScene {
 
    private var gridVM = GridViewModel()
    private var menuVM: MenuViewModel?
    private var calculatorVM: EfmCalculatorViewModel?
    let disposeBag = DisposeBag()
    
    ///Dimensions
    let rectSize = 1500
    let xAxisHeight = 50
    let yAxisWidth = 90
    
    ///Nodes
    let backgroundNode: SKShapeNode
    let pricesXAxisNode: SKShapeNode
    let categoriesYAxisNode: SKShapeNode
    
    override init(size: CGSize) {
        backgroundNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: rectSize, height: rectSize))
        pricesXAxisNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: rectSize, height: xAxisHeight))
        categoriesYAxisNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: yAxisWidth, height: rectSize))
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        log("deinit GameScene")
    }
    
    override func didMove(to view: SKView) {
        log("didMove")
        prepareBackground()
        prepareGrid()

        setupGestures()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.urlRelay
                .subscribe { event in
                    if let urlStr = event.element {
                        self.loadData(urlStr)
                    }
            }.disposed(by: disposeBag)
            
            if let efmUrl = appDelegate.sharedUrl {
                loadData(efmUrl.absoluteString)
            }
        }
        else {
            //loadData("u2")  //test user
        }
        animateCoordinatePlaneAtStart()
    }
    
    //MARK: - loading data
    func loadData(_ feedbacksUrl: String) {
        if feedbacksUrl.isEmpty {
            //show user the menu - so she/he can choose
            menuVM?.openMenu(buttonName: "")
            return
        }
        
        let urlStr = feedbacksUrl.replacingOccurrences(of: "efm://", with: "")
        log("==will show data from \(urlStr)")
        if urlStr.hasPrefix("https://allegro.pl/") {
            log("getFeedbackForPage for allegro")
            getFeedbackFromAllegroPage(pageUrl: urlStr)
        }
        else if urlStr.hasPrefix("ebay") {
            //TODO parse ebay
            logError("!!!   ebay parser not implemented !!!")
        }
        else { //load saved user data from .csv
            getFeedbacksFromCsv(forUser: urlStr)
        }
    }
    
    func getFeedbacksFromCsv(forUser: String) {
        backgroundNode.removeAllChildren()
        let feedHistory = FeedbacksHistory(for: forUser)
        feedHistory.feedbackRelay
            .subscribe { event in
                if let f = event.element {
                    let fVM = FeedbackViewModel(f)
                    fVM.draw(on: self.backgroundNode)
                }
        }.disposed(by: disposeBag)
        
        self.calculatorVM = EfmCalculatorViewModel(relay: feedHistory.feedbackRelay)
        
        feedHistory.readCsvFeedbacks1by1()
    }
    
    func getFeedbackFromAllegroPage(pageUrl: String) {
        backgroundNode.removeAllChildren()
        let allCrawler = AllegroCrawler(itemPage: pageUrl)
        allCrawler.feedbackRelay
            .subscribe { event in
                if let f = event.element {
                    let fVM = FeedbackViewModel(f)
                    fVM.draw(on: self.backgroundNode)
                }
        }.disposed(by: disposeBag)
        
        //TODO subscribe(relay: allCrawler.feedbackRelay)
        
        allCrawler.getItemPage()
            .subscribe { event in
                    if let f = event.element {
                        let fVM = FeedbackViewModel(f)
                        fVM.draw(on: self.backgroundNode)
                    }
            }.disposed(by: disposeBag)
        
    }
    

}
    
//MARK: - prepare layot
extension GameScene {
    fileprivate func animateCoordinatePlaneAtStart() {
        //TODO start point - center on test charge
        let startPoint = CGPoint(x: yAxisWidth, y: xAxisHeight)
        self.animatePan(to: startPoint)
    }
    
    
    fileprivate func animatePan(to p: CGPoint, time: Double = 2.0) {
        let bgMove = SKAction.move(to: p, duration: time)
        let xAxisMove = SKAction.moveTo(x: p.x, duration: time)
        let yAxisMove = SKAction.moveTo(y: p.y, duration: time)
        
        backgroundNode.run(bgMove)
        pricesXAxisNode.run(xAxisMove)
        categoriesYAxisNode.run(yAxisMove)
    }
    
    fileprivate func prepareBackground() {
        backgroundNode.fillColor = .gray
        backgroundNode.name = "backgroundNode"
        self.addChild(backgroundNode)
    }
    
    fileprivate func prepareGrid() {
        pricesXAxisNode.fillColor = .darkGray
        pricesXAxisNode.name = "pricesXAxisNode"
        self.addChild(pricesXAxisNode)
        gridVM.drawPriceLabels(on: pricesXAxisNode)
        
        categoriesYAxisNode.fillColor = .darkGray
        categoriesYAxisNode.name = "categoriesYAxisNode"
        self.addChild(categoriesYAxisNode)
        gridVM.drawCategoriesLabels(on: categoriesYAxisNode)
    }
}


//MARK: - touches and gesture handling
extension GameScene {
    fileprivate func setupGestures() {
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
        view?.addGestureRecognizer(pinchGesture)
    }
    
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        backgroundNode.xScale = backgroundNode.xScale * sender.scale
        backgroundNode.yScale = backgroundNode.yScale * sender.scale
        
        pricesXAxisNode.xScale = pricesXAxisNode.xScale * sender.scale
        categoriesYAxisNode.yScale = categoriesYAxisNode.yScale * sender.scale
        
        sender.scale = 1.0
    }
   
    private func panForTranslation(_ translation: CGPoint) {
        let position = backgroundNode.position
        let newX = position.x + translation.x
        let newY = position.y + translation.y
        let aNewPosition = CGPoint(x: newX, y: newY)
        backgroundNode.position = aNewPosition //self.boundLayerPos(aNewPosition)
        
        self.pricesXAxisNode.position =  CGPoint(x: newX, y: 0)
        self.categoriesYAxisNode.position = CGPoint(x: 0, y: newY)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       guard let touch = touches.first else { return }
       let positionInScene = touch.location(in: self)
       let previousPosition = touch.previousLocation(in: self)
       let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
       
       panForTranslation(translation)
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let buttonName = touchedNode.name {
                logVerbose("touchedNode.name buttonName= \(buttonName)")
                menuVM?.handleClick(buttonName: buttonName)
            }
        }
    }
}

//MARK: - Menus
extension GameScene {
    public func setupMenu(size: CGSize) {
        let rightEdge = size.width
        let upperEdge = size.height
        menuVM = MenuViewModel(corner: CGPoint(x: rightEdge, y: upperEdge), gameSceneDelegate: self)
        redrawMenu()
    }
    
    fileprivate func redrawMenu() {
        if let oldMenu = self.childNode(withName: "menuNode") {
            oldMenu.removeFromParent()
        }
        
        if let menuNode = menuVM?.drawMenu() {
            menuNode.name = "menuNode"
            menuNode.zPosition = Layers.menuBacground
        
            self.addChild(menuNode)
        }
    }
}
