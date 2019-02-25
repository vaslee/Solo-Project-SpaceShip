//
//  EndScene.swift
//  SoloProjectSpaceShip
//
//  Created by TingxinLi on 2/25/19.
//  Copyright © 2019 TingxinLi. All rights reserved.
//

import Foundation
import SpriteKit

class EndScene: SKScene {
    
    //var restartButton: SKNode! = nil
    
    var restartButton : UIButton!
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "endscene")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0 //分裂的屏幕页面
        addChild(background)
        
        restartButton.setTitle("Restart", for: .normal)
        restartButton.setTitleColor(.white, for: .normal)
        restartButton.frame = CGRect(x: view.frame.size.width - 60, y: 60, width: 50, height: 50)
        restartButton.addTarget(self, action: #selector(restartAction), for: .touchUpInside)
        //self.addChild(restartButton)
        
        
//        restartButton = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 100))
//        restartButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
//        restartButton.userInteractionEnabled = true
//        self.addChild(restartButton)

    }
    
    @objc func restartAction() {
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFade(withDuration: 1.0))
    }
    
    
}
