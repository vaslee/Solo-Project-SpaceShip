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
    
    var highScoreDefault: Int!
    let restart = SKSpriteNode(imageNamed: "restart")
    let menu = SKSpriteNode(imageNamed: "options")
    var currentSpeed = 0.0
    var endSpace: CGRect
    
    override init(size: CGSize) {
        let maxRatio: CGFloat = 16.0/9.0
        let endWidth = size.height/maxRatio
        let endSide = (size.width - endWidth) / 2
        
        endSpace = CGRect(x: endSide, y: 0, width: endWidth, height: size.height)
        
        
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
        
        
        let gameOverLabel = SKLabelNode(fontNamed: "fighting spirit TBS")
        gameOverLabel.fontSize = 60
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
        gameOverLabel.zPosition = 10
        addChild(gameOverLabel)
        
        let scaleUp = SKAction.scale(to: 2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1, duration: 0.5)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        gameOverLabel.run(scaleSequence)
        
        let scoreLabel = SKLabelNode(fontNamed: "fighting spirit TBS")
        scoreLabel.fontSize = 35
        scoreLabel.text = "Score: \(countScore)"
        scoreLabel.fontColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.5)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)

        let defaults = UserDefaults.standard
        var highScoreNum = defaults.integer(forKey: "saveHighScore")
        
        
        if countScore > highScoreNum {
            highScoreNum = countScore
            defaults.setValue(highScoreNum, forKey: "saveHighScore")
        }

        
        
        
        let highestScore = SKLabelNode(fontNamed: "fighting spirit TBS")
        highestScore.fontSize = 40
        highestScore.text = "HighestScore: \(highScoreNum)"
        highestScore.fontColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        highestScore.position = CGPoint(x: self.size.width/2, y: self.size.height*0.6)
        highestScore.zPosition = 10
        addChild(highestScore)
        
        let backgroundMusic = SKAudioNode(fileNamed: "gameOver.mp3")
        backgroundMusic.autoplayLooped = true
        backgroundMusic.run(SKAction.stop())
        addChild(backgroundMusic)
        
        
        restart.setScale(1)
        restart.position = CGPoint(x: self.size.width/1.65, y: self.size.height*0.4)
        restart.zPosition = 10
        addChild(restart)
        
        menu.setScale(1)
        menu.position = CGPoint(x: self.size.width/2.5, y: self.size.height*0.4)
        menu.zPosition = 10
        addChild(menu)
        

   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if restart.contains(location) {

                let gameScene = GameScene(size: view!.bounds.size)
                gameScene.startingSpeed = currentSpeed
                view?.presentScene(gameScene)
            }
            
            if menu.contains(location) {
                 let menuScene = MenuScene(size: view!.bounds.size)
                view?.presentScene(menuScene)
            }
            
        }
    }

}
