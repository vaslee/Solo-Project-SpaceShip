//
//  GameScene.swift
//  SoloProjectSpaceShip
//
//  Created by TingxinLi on 2/5/19.
//  Copyright © 2019 TingxinLi. All rights reserved.
//

import Foundation
import SpriteKit

var countScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var heart = 3
    var startingSpeed = 0.0
    var scoreLabel = SKLabelNode(fontNamed: "Bold of Roof Runner")
    
    var highScore = Int()
    var timer = Timer()
    var heartLabel = SKLabelNode(fontNamed: "Bold of Roof Runner")
    
    let spaceShip = SKSpriteNode(imageNamed: "ship")
    let stopButton = SKSpriteNode(imageNamed: "stop")
    let menuButton = SKSpriteNode(imageNamed: "options")
    
    let bulletSound = SKAction.playSoundFileNamed("bulletsSound.wav", waitForCompletion: false)
    
    let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    
    struct physicsCaegories {
        static let noun: UInt32 = 0
        static let ship: UInt32 = 0b1
        static let bullet: UInt32 = 0b10
        static let enemy: UInt32 = 0b100
        static let enemyBullet: UInt32 = 0b1000
    }

    
    var gameSpace: CGRect
    
    override init(size: CGSize) {
        let maxRatio: CGFloat = 16.0/9.0
        let gameWidth = size.height/maxRatio
        let gameSide = (size.width - gameWidth) / 2
        gameSpace = CGRect(x: gameSide, y: 0, width: gameWidth, height: size.height)
        
        
        super.init(size: size)
         startNewLevel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        countScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1 { // 0...1就是会显示俩次
            let background = SKSpriteNode(imageNamed: "background1")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0 //分裂的屏幕页面
            background.name = "Background"
            addChild(background)
        }
       
        spaceShip.setScale(0.2) //change the size of image
        spaceShip.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.13)
        spaceShip.zPosition = 2 // 是2 因为1 的时候我们还要放子弹
        spaceShip.physicsBody = SKPhysicsBody(rectangleOf: spaceShip.size)
        spaceShip.physicsBody!.affectedByGravity = false
        spaceShip.physicsBody!.categoryBitMask = physicsCaegories.ship
        spaceShip.physicsBody!.collisionBitMask = physicsCaegories.noun
        spaceShip.physicsBody!.contactTestBitMask = physicsCaegories.enemy
        addChild(spaceShip)
        
        
        let backgroundMusic = SKAudioNode(fileNamed: "gameSound.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.05, y: self.size.height*0.95 )
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
        
        
        heartLabel.text = "Heart: 3"
        heartLabel.fontSize = 25
        heartLabel.fontColor = SKColor.red
        heartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        heartLabel.position = CGPoint(x: self.size.width*0.95, y: self.size.height*0.95 )
        heartLabel.zPosition = 100
        addChild(heartLabel)
        
        
        var highScoreDefault = UserDefaults.standard
        if (highScoreDefault.value(forKey: "HighScore") != nil) {
            highScore = highScoreDefault.value(forKey: "HighScore") as! NSInteger
        } else {
            highScore = 0
        }
        
            enemyBulletShow()
            stopPressed()
            menuPressed()
        
    }
    // 背景移动
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var backgroundToMoveBySecond: CGFloat = 200.0 // 页面移动速度
    // 实时更新背景图
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let backgroundToMove = backgroundToMoveBySecond * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "Background") { (background, stop) in
           
            let gameScene = GameScene(size: self.view!.bounds.size) // 设置只在gamescene的时候移动背景画面
            if gameScene == gameScene{
            background.position.y -= backgroundToMove
            }
            if background.position.y < -self.size.height { // 当页面向下移动时的y 小于一开始设定的y的值，
                background.position.y += self.size.height*2 // 那么就*2 这样h就会一直显示
            }
        }
    }
    
    
    func addScore() {
        countScore += 1
        scoreLabel.text = "Score: \(countScore)"
        
    }
    
    func loseLife() {
        heart -= 1
        heartLabel.text = "Heart: \(heart)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        heartLabel.run(scaleSequence)
    }
    
    func stopPressed() {
        stopButton.setScale(1)
        stopButton.position = CGPoint(x: self.size.width/1.1, y: self.size.height*0.85)
        stopButton.zPosition = 50
        addChild(stopButton)
        
    }
    
    func menuPressed() {
        menuButton.setScale(1)
        menuButton.position = CGPoint(x: self.size.width/11, y: self.size.height*0.85)
        menuButton.zPosition = 50
        addChild(menuButton)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) { // 当俩个object相遇时用的code

        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if firstBody.categoryBitMask == 0 && secondBody.categoryBitMask == 1 { // 0 = 敌军飞船， 1 = 我的飞船
            
            if firstBody.node != nil {
            hitExpolosion(hitPosition: firstBody.node!.position)
            }
            if secondBody.node != nil {

            hitExpolosion(hitPosition: secondBody.node!.position)
            }
            loseLife()
           
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            if heart > 0 {
                addChild(spaceShip)
            } else if heart == 0 {
                gameOver()
            }
                }
        
        if firstBody.categoryBitMask == 0 && secondBody.categoryBitMask == 2 { // 0 = 敌军飞船， 2 = 我的子弹值
            
            addScore()
            if secondBody.node != nil {
            hitExpolosion(hitPosition: secondBody.node!.position)
            }
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            
           
        }
        
        if firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 8 { // 1 = 我的飞船， 8 = 敌军子弹值
            if firstBody.node != nil {
                hitExpolosion(hitPosition: firstBody.node!.position)
            }
            if secondBody.node != nil {
                
                hitExpolosion(hitPosition: secondBody.node!.position)
            }
            
            loseLife()
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            if heart > 0 {
                addChild(spaceShip)
            } else if heart == 0 {
                gameOver()
            }
        
        }
        
        if firstBody.categoryBitMask == 2 && secondBody.categoryBitMask == 8 { // 2 = 我的子弹值， 8 = 敌军子弹值
            if firstBody.node != nil {
                hitExpolosion(hitPosition: firstBody.node!.position)
            }
            if secondBody.node != nil {
                
                hitExpolosion(hitPosition: secondBody.node!.position)
            }
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
        }

    }
    

    
    func hitExpolosion(hitPosition: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = hitPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        addChild(explosion)
        
        let scale = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
      
        let explotionSequence = SKAction.sequence([explosionSound,scale, fadeOut, delete])
        explosion.run(explotionSequence)
    }
    
    func startNewLevel() {
        
        let enemyShow = SKAction.run(enemyShowup)
        let timeToShow = SKAction.wait(forDuration: 1.5)
        
        let enemyShowSequce = SKAction.sequence([enemyShow, timeToShow])
        let enemyShowForever = SKAction.repeatForever(enemyShowSequce)
        run(enemyShowForever)
        
    }
    
    func fireBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "fire")
        bullet.setScale(0.15)
        bullet.position = spaceShip.position //子弹射出的地方是和飞船一样的位置
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = physicsCaegories.bullet
        bullet.physicsBody!.collisionBitMask = physicsCaegories.noun
        bullet.physicsBody!.contactTestBitMask = physicsCaegories.enemy | physicsCaegories.enemyBullet
        addChild(bullet)
        
        //let soundAction = SKAction.playSoundFileNamed("bulletsSound.wav", waitForCompletion: true)
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)//moveY 因为我们需要子弹不断上升（y），子弹上升后会聚集在最顶部，所以需要做下面这个步骤
        let deleteBullet = SKAction.removeFromParent() // 这一步让所有的子弹全部消失在最顶端

        let bulletSequce = SKAction.sequence([bulletSound, moveBullet, deleteBullet]) //发射子弹的所有步骤在【】里面排序，code会根据我们的排序进行action
        bullet.run(bulletSequce)
        
    }
    
    
    func gameOver() {
        let endScene = EndScene(size: view!.bounds.size)
        endScene.currentSpeed = startingSpeed
        view?.presentScene(endScene, transition: SKTransition.doorsCloseHorizontal(withDuration: 0.5))
    }
    
    func enemyShowup() {
        
       let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.setScale(0.3)
        enemy.zPosition = 2
        let minValue = self.size.width / 8
        let maxValue = self.size.width + 45
        let enemyPoint = UInt32(maxValue - minValue)
        enemy.position = CGPoint(x: CGFloat(arc4random_uniform(enemyPoint)), y: self.size.height)
        var scoreSpeed = Double()
        if (countScore%15 == 0) { // 每得分15 速度增加0.3
            scoreSpeed = Double(countScore) / 15.0 * 0.3
        }
        let currentSpeed = startingSpeed - scoreSpeed //用当前速度减去 0.3 之后的新速度产生
        let enemyAction = SKAction.moveTo(y: -70, duration: currentSpeed)
        enemy.run(SKAction.repeatForever(enemyAction))
        
        let deleteEnemyBullet = SKAction.removeFromParent()
        let enemyBulletSequce = SKAction.sequence([bulletSound, enemyAction, deleteEnemyBullet])
        enemy.run(enemyBulletSequce)
        
        enemy.name = "enemyShip"
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody!.categoryBitMask = physicsCaegories.noun
        enemy.physicsBody!.contactTestBitMask = physicsCaegories.ship | physicsCaegories.bullet
        addChild(enemy)
        
    }
    
    
    func enemyBulletShow() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(shootBullet), userInfo: nil, repeats: true)
    }

    @objc func shootBullet() {
        for node in self.children {
            if (node.name == "enemyShip") {
            
                let enemyBullet = SKSpriteNode(imageNamed: "enemyBullet")
                enemyBullet.setScale(0.2)
                enemyBullet.position = node.position //子弹射出的地方是和飞船一样的位置
                enemyBullet.zPosition = 1
               //enemyBullet.zRotation = 3.5
                enemyBullet.physicsBody = SKPhysicsBody(rectangleOf: enemyBullet.size)
                enemyBullet.physicsBody!.affectedByGravity = false
                //enemyBullet.physicsBody?.isDynamic = false
                enemyBullet.physicsBody!.categoryBitMask = physicsCaegories.enemyBullet
                enemyBullet.physicsBody!.collisionBitMask = physicsCaegories.noun
                enemyBullet.physicsBody!.contactTestBitMask = physicsCaegories.ship | physicsCaegories.bullet
                addChild(enemyBullet)


                let moveBullet = SKAction.moveTo(y: -self.size.height - enemyBullet.size.height, duration: 2.5)
                let deleteBullet = SKAction.removeFromParent()

                let bulletSequce = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
                enemyBullet.run(bulletSequce)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       fireBullet()
        for touch in touches {
            let location = touch.location(in: self)
            if stopButton.contains(location) {
                if self.scene?.view?.isPaused == false {
                    self.scene?.view?.isPaused = true
                } else {
                    self.scene?.view?.isPaused = false
                }
            }
            if menuButton.contains(location) {
                let menuScene = MenuScene(size: view!.bounds.size)
                view?.presentScene(menuScene)
            }
        }
    }
     
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let touchPoint = touch.location(in: self)
            let previousTouchPoint = touch.previousLocation(in: self)
            let amountDraggedX = touchPoint.x - previousTouchPoint.x
            let amountDraggedY = touchPoint.y - previousTouchPoint.y
            
            spaceShip.position.x += amountDraggedX
            spaceShip.position.y += amountDraggedY
           
            
            if spaceShip.position.x > gameSpace.maxX - spaceShip.size.width / 3.5 {
                spaceShip.position.x = gameSpace.maxX - spaceShip.size.width / 3.5
            }
            if spaceShip.position.x < gameSpace.minX + spaceShip.size.width / 3.5 {
                spaceShip.position.x = gameSpace.minX + spaceShip.size.width / 3.5
            }
            
            if spaceShip.position.y > gameSpace.maxY - spaceShip.size.height / 2.5 {
                spaceShip.position.y = gameSpace.maxY - spaceShip.size.height / 2.5
            }
            if spaceShip.position.y < gameSpace.minY  + spaceShip.size.height / 2.5 {
                spaceShip.position.y = gameSpace.minY + spaceShip.size.height / 2.5
            }
        }
    }

}
    

