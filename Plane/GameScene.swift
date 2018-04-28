//
//  GameScene.swift
//  Plane
//
//  Created by Разработчик on 25.04.18.
//  Copyright © 2018 Разработчик. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bg = Element()
    var plane = Element()
    var badPlane = Element()
    var bullet = Element()
    var arrowRight = Element()
    
    // Button
    var playButton: UIButton!
    
    // Sprite Nodes
    var scoreLable = SKLabelNode()
    var hightScoreLable = SKLabelNode()
    //Sprite Object
    
    var lableObject = SKNode()
    // Bitmask
    var planeBitMask: UInt32 = 0x1 << 1
    var badPlaneBitMask: UInt32 = 0x1 << 2
    var bulletBitMask: UInt32 = 0x1 << 3
    var arrowBitMask: UInt32 = 0x1 << 4
    
    // Animate With Texture
    var planeFlyTextureArray = [SKTexture]()
    var planeShootTextureArray = [SKTexture]()
    var badPlaneFlyTextureArray = [SKTexture]()
    
    //Timer
    var timerAddBadPlane = Timer()
    
    // Counter
    var timeIntervalForCreate: Double = 3
    var currentLocationY: CGFloat = 0
    
    var hightScore = 0 {
        didSet{
            self.hightScoreLable.text = "Hight score - \(hightScore)"
        }
    }
    var score = 0 {
        didSet{
            self.scoreLable.text = "\(score)"
            
            if timeIntervalForCreate > 1.1 {
                timeIntervalForCreate = 3 - Double(score) * 1
                timerForAddBadPlane()
            }
        }
    }
    var gameIsPaused = false {
        didSet{
            playButton.isHidden = !gameIsPaused
            if gameIsPaused {
                stopGame()
            } else {
                playGame()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        bg.texture = SKTexture(imageNamed: "BG.png")
        plane.texture = SKTexture(imageNamed: "Fly1.png")
        badPlane.texture = SKTexture(imageNamed: "badFly1.png")
        arrowRight.texture = SKTexture(imageNamed: "right.png")
        
        bullet.texture = SKTexture(imageNamed: "Bullet1.png")
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        createGame()
    }
    
    func createObjects() {
        self.addChild(bg.objectNode)
        self.addChild(plane.objectNode)
        self.addChild(badPlane.objectNode)
        self.addChild(arrowRight.objectNode)
        self.addChild(bullet.objectNode)
        self.addChild(lableObject)
    }
    
    func createGame() {
        createBg()
       
        createPlane()
        timerForAddBadPlane()
        addArrows()
        addScoreLable()
        addHightScoreLable()
    }
    
    func addScoreLable () {
        scoreLable.text = "0"
        scoreLable.position = CGPoint(x: frame.maxX / 2, y: frame.maxY - 150)
        scoreLable.fontSize = 35
        scoreLable.fontColor = .black
        scoreLable.zPosition = 2
        lableObject.addChild(scoreLable)
    }
    func addHightScoreLable () {
        hightScoreLable.text = "Hight score - 0"
        hightScoreLable.position = CGPoint(x: frame.maxX - 150, y: frame.maxY - 150)
        hightScoreLable.fontSize = 35
        hightScoreLable.fontColor = .black
        hightScoreLable.zPosition = 2
        lableObject.addChild(hightScoreLable)
    }
    
    func createBg() {
        bg.texture = SKTexture(imageNamed: "BG.png")
        
        let moveBg = SKAction.moveBy(x: -bg.texture.size().width, y: 0, duration: 3)
        let replaceBg = SKAction.moveBy(x: bg.texture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg,replaceBg]))
        
        for i in 0...2 {
            bg.spriteNode = SKSpriteNode(texture: bg.texture)
            bg.spriteNode.position = CGPoint(x: size.width/4 + (bg.texture.size().width - 1) * CGFloat(i), y: size.height/2)
            bg.spriteNode.size.height = self.frame.height
            bg.spriteNode.run(moveBgForever)
            bg.spriteNode.zPosition = -1
            
            bg.objectNode.addChild(bg.spriteNode)
        }
    }
    func addPlane(planeSpriteNode: SKSpriteNode, atPosition position: CGPoint) {
        
        plane.spriteNode = SKSpriteNode(texture: plane.texture)
        
    
        planeFlyTextureArray = [SKTexture(imageNamed: "Fly1.png"),SKTexture(imageNamed: "Fly2.png")]
        planeShootTextureArray = [SKTexture(imageNamed: "Shoot1.png"),SKTexture(imageNamed: "Shoot2.png"),SKTexture(imageNamed: "Shoot3.png"),SKTexture(imageNamed: "Shoot4.png"),SKTexture(imageNamed: "Shoot5.png")]
        let planeFlyAnimation = SKAction.animate(with: planeFlyTextureArray, timePerFrame: 0.1)
        let flyPlane = SKAction.repeatForever(planeFlyAnimation)
        plane.spriteNode.run(flyPlane)
        
        plane.spriteNode.position = position
        currentLocationY = position.y
        plane.spriteNode.size.height = 84
        plane.spriteNode.size.width = 120
        
        plane.spriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: plane.spriteNode.size.width - 40 , height: plane.spriteNode.size.height - 30))
        plane.spriteNode.physicsBody?.categoryBitMask = planeBitMask
        plane.spriteNode.physicsBody?.contactTestBitMask = badPlaneBitMask
        
        plane.spriteNode.physicsBody?.isDynamic = true
        plane.spriteNode.physicsBody?.affectedByGravity = false
        plane.spriteNode.physicsBody?.allowsRotation = false
        plane.spriteNode.zPosition = 1
        
        plane.objectNode.removeAllChildren()
        plane.objectNode.addChild(plane.spriteNode)
        
    }
    
    func createPlane() {
        addPlane(planeSpriteNode: plane.spriteNode, atPosition: CGPoint(x: self.size.width / 4, y: frame.maxY / 2))
    
    }
    
    @objc func addBadPlane() {
        badPlane.spriteNode = SKSpriteNode(texture: badPlane.texture)
        
        badPlaneFlyTextureArray = [SKTexture(imageNamed: "badFly1.png"),SKTexture(imageNamed: "badFly2.png")]
        let badPlaneFlyAnimation = SKAction.animate(with: badPlaneFlyTextureArray, timePerFrame: 0.1)
        let badFlyPlane = SKAction.repeatForever(badPlaneFlyAnimation)
        
        badPlane.spriteNode.run(badFlyPlane)
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipOffset = CGFloat(movementAmount) - self.frame.height / 4
       
        badPlane.spriteNode.size.height = 42
        badPlane.spriteNode.size.width = 60
        
        badPlane.spriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: badPlane.spriteNode.size.width - 10 , height: badPlane.spriteNode.size.height - 8))
        badPlane.spriteNode.physicsBody?.restitution = 0
        badPlane.spriteNode.position = CGPoint(x: self.size.width + 50, y: badPlane.texture.size().height + 98 + pipOffset)
        
        let moveBad = SKAction.moveBy(x: -self.frame.size.width, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let badMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveBad,removeAction]))
        
        badPlane.spriteNode.run(badMoveBgForever)
        badPlane.spriteNode.physicsBody?.isDynamic = false
        badPlane.spriteNode.physicsBody?.categoryBitMask = badPlaneBitMask
        badPlane.spriteNode.zPosition = 1
        
        badPlane.objectNode.addChild(badPlane.spriteNode)
        
    }
    
    func timerForAddBadPlane() {
        timerAddBadPlane.invalidate()
        timerAddBadPlane = Timer.scheduledTimer(timeInterval: timeIntervalForCreate, target: self, selector: #selector(addBadPlane), userInfo: nil, repeats: true)
    }
    
    
    func addArrows() {
        arrowRight.spriteNode = SKSpriteNode(texture: arrowRight.texture)
        
        arrowRight.spriteNode.position = CGPoint(x: frame.maxX - 100, y: 150)
        arrowRight.spriteNode.physicsBody?.isDynamic = false
        arrowRight.spriteNode.zPosition = 2
        arrowRight.spriteNode.size.height = 105
        arrowRight.spriteNode.size.width = 150
        arrowRight.objectNode.addChild(arrowRight.spriteNode)
    }
    
    func createBullet(position: CGPoint) {
        bullet.spriteNode = SKSpriteNode(texture: bullet.texture)
        bullet.spriteNode.size.height = 20
        bullet.spriteNode.size.width = 30
        bullet.spriteNode.position = position
        
        let moveBad = SKAction.moveBy(x: self.frame.size.width, y: 0, duration: 4)
        let removeAction = SKAction.removeFromParent()
        let badMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveBad,removeAction]))
        bullet.spriteNode.run(badMoveBgForever)
        
        bullet.spriteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20 , height: 30))
        bullet.spriteNode.physicsBody?.isDynamic = true
        bullet.spriteNode.physicsBody?.affectedByGravity = false
        bullet.spriteNode.physicsBody?.categoryBitMask = bulletBitMask
        bullet.spriteNode.physicsBody?.contactTestBitMask = badPlaneBitMask
        bullet.spriteNode.zPosition = 1
        
        bullet.objectNode.addChild(bullet.spriteNode)
    }
    
    func stopGame() {
        bg.objectNode.speed = 0
        badPlane.objectNode.speed = 0
        bullet.objectNode.speed = 0
        timerAddBadPlane.invalidate()
    }
    func playGame() {
        bg.objectNode.speed = 1
        badPlane.objectNode.speed = 1
        bullet.objectNode.speed = 1
        timerForAddBadPlane()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
}
