//
//  GameScene.swift
//  SoloProjectSpaceShip
//
//  Created by TingxinLi on 2/5/19.
//  Copyright © 2019 TingxinLi. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var countScore = 0
    var scoreLabel = SKLabelNode(fontNamed: "Bold of Roof Runner")
    
    let spaceShip = SKSpriteNode(imageNamed: "SpaceShip")
    
    let bulletSound = SKAction.playSoundFileNamed("bulletsSound.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    struct physicsCaegories {
        static let noun: UInt32 = 0
        static let ship: UInt32 = 0b1
        static let bullet: UInt32 = 0b10
        static let enemy: UInt32 = 0b100
    }

    
    var gameSpace: CGRect
    
    override init(size: CGSize) {
        let maxRatio: CGFloat = 16.0/9.0
        let gameWidth = size.height/maxRatio
        let gameSide = (size.width - gameWidth) / 2
        //let gameHigh = size.height
        gameSpace = CGRect(x: gameSide, y: 0, width: gameWidth, height: size.height)
        
        
        super.init(size: size)
        
       startNewLevel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0 //分裂的屏幕页面
        addChild(background)
        
       
        spaceShip.setScale(0.1) //change the size of image
        spaceShip.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.13)
        spaceShip.zPosition = 2 // 是2 因为1 的时候我们还要放子弹
        spaceShip.physicsBody = SKPhysicsBody(rectangleOf: spaceShip.size)
        spaceShip.physicsBody!.affectedByGravity = false
        spaceShip.physicsBody!.categoryBitMask = physicsCaegories.ship
        spaceShip.physicsBody!.collisionBitMask = physicsCaegories.noun
        spaceShip.physicsBody!.contactTestBitMask = physicsCaegories.enemy
        addChild(spaceShip)
        
        let backgroundMusic = SKAudioNode(fileNamed: "spaceinvaders1.mpeg")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.05, y: self.size.height*0.95 )
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
        
        
        
    }
    
    func addScore() {
        countScore += 1
        scoreLabel.text = "Score: \(countScore)"
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
//        var firstBody: SKPhysicsBody = contact.bodyA
//        var secondBody: SKPhysicsBody = contact.bodyB
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if firstBody.categoryBitMask == 0 && secondBody.categoryBitMask == 1 {
            
            if firstBody.node != nil {
            hitExpolosion(hitPosition: firstBody.node!.position)
            }
            if secondBody.node != nil {

            hitExpolosion(hitPosition: secondBody.node!.position)
            }
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
                }
        if firstBody.categoryBitMask == 0 && secondBody.categoryBitMask == 2 {
            
            addScore()
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
        
        let bullet = SKSpriteNode(imageNamed: "Bullets")
        //let bullet = SKSpriteNode(imageNamed: "Bullets")
        bullet.setScale(0.1)
        bullet.position = spaceShip.position //子弹射出的地方是和飞船一样的位置
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = physicsCaegories.bullet
        bullet.physicsBody!.collisionBitMask = physicsCaegories.noun
        bullet.physicsBody!.contactTestBitMask = physicsCaegories.enemy
        addChild(bullet)
        
        //let soundAction = SKAction.playSoundFileNamed("bulletsSound.wav", waitForCompletion: true)
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)//moveY 因为我们需要子弹不断上升（y），子弹上升后会聚集在最顶部，所以需要做下面这个步骤
        let deleteBullet = SKAction.removeFromParent() // 这一步让所有的子弹全部消失在最顶端
        let bulletSequce = SKAction.sequence([bulletSound, moveBullet, deleteBullet]) //发射子弹的所有步骤在【】里面排序，code会根据我们的排序进行action
        bullet.run(bulletSequce)
        
        
    }
    
    func enemyShowup() {
        //        let randomXStart = random(min: gameSpace.minX, max: gameSpace.maxX)
        //        let randomXEnd = random(min: gameSpace.minX, max: gameSpace.maxX)
        //        let startPoint = CGPoint(x: randomXStart, y: self.size.height)//1.5
        let enemy = SKSpriteNode(imageNamed: "enemy2")
        enemy.setScale(0.1)
        enemy.zPosition = 2
        let minValue = self.size.width / 8
        let maxValue = self.size.width + 45
        let enemyPoint = UInt32(maxValue - minValue)
        enemy.position = CGPoint(x: CGFloat(arc4random_uniform(enemyPoint)), y: self.size.height)

        let enemyAction = SKAction.moveTo(y: -70, duration: 1.5)
        enemy.run(SKAction.repeatForever(enemyAction))
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = physicsCaegories.enemy
        enemy.physicsBody!.categoryBitMask = physicsCaegories.noun
        enemy.physicsBody!.contactTestBitMask = physicsCaegories.ship | physicsCaegories.bullet
        addChild(enemy)

//        let randomXStart = random(min: gameSpace.minX, max: gameSpace.maxX)
//        let randomXEnd = random(min: gameSpace.minX, max: gameSpace.maxX)
//        let startPoint = CGPoint(x: randomXStart, y: self.size.height)//1.5
//        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height)//0.2
       
        
//        let enemy = SKSpriteNode(imageNamed: "enemy2")
//        enemy.setScale(0.1)
//         let randomY = random(min: enemy.size.width/2, max: size.width - enemy.size.width/2)
//        enemy.position = CGPoint(x: size.width + enemy.size.height/2, y: randomY)0
//        let randomY = random(min: enemy.size.width/2, max: size.width - enemy.size.width)
//        enemy.position = CGPoint(x: size.height + enemy.size.width/2, y: randomY)
//        enemy.zPosition = 2
//        addChild(enemy)
//
//         let enemySpeed = random(min: CGFloat(2.0), max: CGFloat(4.0))
//        let actionMove = SKAction.move(to: CGPoint(x: randomY, y: -enemy.size.width/2),
//                                       duration: TimeInterval(enemySpeed))
//        let actionMoveDone = SKAction.removeFromParent()
//        enemy.run(SKAction.sequence([actionMove, actionMoveDone]))
//        let moveEnemy = SKAction.move(to: endPoint, duration: 1.0)
//        let deleteEnemy = SKAction.removeFromParent()
//        let enemySequce = SKAction.sequence([moveEnemy, deleteEnemy])
//        enemy.run(enemySequce)
//
//        let dx = endPoint.x - startPoint.x
//        let dy = endPoint.y - startPoint.y
//        let amountOfRotate = atan2(dy, dx)
//        enemy.zPosition = amountOfRotate
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
        //enemyShowup()
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
