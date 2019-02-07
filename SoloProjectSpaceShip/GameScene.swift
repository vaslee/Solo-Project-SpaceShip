//
//  GameScene.swift
//  SoloProjectSpaceShip
//
//  Created by TingxinLi on 2/5/19.
//  Copyright © 2019 TingxinLi. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    let spaceShip = SKSpriteNode(imageNamed: "SpaceShip")
    
    let bulletSound = SKAction.playSoundFileNamed("bulletsSound.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0 //分裂的屏幕页面
        addChild(background)
        
       
        spaceShip.setScale(0.15) //change the size of image
        spaceShip.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.13)
        spaceShip.zPosition = 2 // 是2 因为1 的时候我们还要放子弹
        addChild(spaceShip)
        
        let backgroundMusic = SKAudioNode(fileNamed: "spaceinvaders1.mpeg")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func fireBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "Bullets")
        //let bullet = SKSpriteNode(imageNamed: "Bullets")
        bullet.setScale(0.1)
        bullet.position = spaceShip.position //子弹射出的地方是和飞船一样的位置
        bullet.zPosition = 1
        addChild(bullet)
        
        //let soundAction = SKAction.playSoundFileNamed("bulletsSound.wav", waitForCompletion: true)
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)//moveY 因为我们需要子弹不断上升（y），子弹上升后会聚集在最顶部，所以需要做下面这个步骤
        let deleteBullet = SKAction.removeFromParent() // 这一步让所有的子弹全部消失在最顶端
        let bulletSequce = SKAction.sequence([bulletSound, moveBullet, deleteBullet]) //发射子弹的所有步骤在【】里面排序，code会根据我们的排序进行action
        bullet.run(bulletSequce)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        <#code#>
//    }
//
    
    
}
