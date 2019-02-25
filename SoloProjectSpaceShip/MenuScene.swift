//
//  MenuScene.swift
//  SoloProjectSpaceShip
//
//  Created by TingxinLi on 2/7/19.
//  Copyright © 2019 TingxinLi. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0 //分裂的屏幕页面
        addChild(background)
        
        
        
        
        
        
        
    }
}
