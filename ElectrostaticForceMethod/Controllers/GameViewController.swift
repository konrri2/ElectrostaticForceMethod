//
//  GameViewController.swift
//  ElectrostaticForceMethod
//
//  Created by Konrad Leszczyński on 28/08/2019.
//  Copyright © 2019 konrri. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var scene: GameScene?
      
    override func viewDidLoad() {
        super.viewDidLoad()

        //oldSize = view.bounds.size
        prepareGameScene()
        prepareMenu()
    }

    //nie didLayout bo po kazdym layout musi robic jescze raz i sie zaptela
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        prepareMenu()
    }
    
    private func prepareGameScene() {
        guard let view = self.view as! SKView? else { return }
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
        view.showsDrawCount = true
        
        scene = GameScene(size: view.bounds.size)
        scene?.scaleMode = .aspectFill
        view.presentScene(scene)
    }
    
    private func prepareMenu() {
//        if #available(iOS 11.0, *), let view = self.view {
//            logVerbose("prepareMenu self.view.safeAreaLayoutGuide = \(self.view.safeAreaLayoutGuide)")
//            view.frame = self.view.safeAreaLayoutGuide.layoutFrame  //safe area is important for iPhones with the notch -> therfore i need to move it to viewWillLayoutSubviews
//        }
////        
////        if #available(macCatalyst 10.15, *), let view = self.view {
////            //TODO
////            view.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
////        }
//        logVerbose("prepareMenu view.bounds.size = \(view.bounds.size)")
        scene?.setupMenu(size: self.view.frame.size)
    }
 
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
