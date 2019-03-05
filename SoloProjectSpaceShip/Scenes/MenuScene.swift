//
//  MenuScene.swift
//  SoloProjectSpaceShip
//
//  Created by TingxinLi on 2/7/19.
//  Copyright © 2019 TingxinLi. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    
    let startGame = SKSpriteNode(imageNamed: "play2")
    
    let easy = SKSpriteNode(imageNamed: "easy")
    
    let medium = SKSpriteNode(imageNamed: "medium")
    
    let hard = SKSpriteNode(imageNamed: "hard")
    
    
    var menuSpace: CGRect
    
    override init(size: CGSize) {
        let maxRatio: CGFloat = 16.0/9.0
        let menuWidth = size.height/maxRatio
        let menuSide = (size.width - menuWidth) / 2
        menuSpace = CGRect(x: menuSide, y: 0, width: menuWidth, height: size.height)
        
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "menu")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0 //分裂的屏幕页面
        addChild(background)
        
        
        let welcome = SKLabelNode(fontNamed: "induction")
        welcome.fontSize = 30
        welcome.text = "Space Ship"
        welcome.fontColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        welcome.position = CGPoint(x: self.size.width/2, y: 400)
        welcome.zPosition = 10
        addChild(welcome)
        
        let scaleUp = SKAction.scale(to: 2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1, duration: 0.5)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        welcome.run(scaleSequence)
        
        
        startGame.setScale(1)
        startGame.position = CGPoint(x: self.size.width/2, y: self.size.height/2.2)
        startGame.zPosition = 10
        addChild(startGame)
        
        easy.setScale(1)
        easy.position = CGPoint(x: self.size.width/2, y: 230)
        easy.zPosition = 10
        addChild(easy)
        
        medium.setScale(1)
        medium.position = CGPoint(x: self.size.width/2, y: 170)
        medium.zPosition = 10
        addChild(medium)
        
        hard.setScale(1)
        hard.position = CGPoint(x: self.size.width/2, y: 110)
        hard.zPosition = 10
        addChild(hard)
        
        
    }
    

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if startGame.contains(location) {
                
                let gameScene = GameScene(size: view!.bounds.size)
                gameScene.startingSpeed = 3.0
                view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 0.5))
            }
            
            if easy.contains(location) {
                
                let gameScene = GameScene(size: view!.bounds.size)
                gameScene.startingSpeed = 3.0
                view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 0.5))
            }
            
            if medium.contains(location) {
                
                
                let gameScene = GameScene(size: view!.bounds.size)
                gameScene.startingSpeed = 2.0
                view?.presentScene(gameScene, transition: SKTransition.doorsOpenVertical(withDuration: 0.5))
            }
            
            if hard.contains(location) {
                
                
                let gameScene = GameScene(size: view!.bounds.size)
                gameScene.startingSpeed = 1.0
                view?.presentScene(gameScene, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
            }
            
            

        }
    }
    
}
