//
//  GameScene.swift
//  Plane
//
//  Created by Разработчик on 25.04.18.
//  Copyright © 2018 Разработчик. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    //Texture
    var bgTexture: SKTexture!
    var planeTexture: SKTexture!
    var badPlaneTexture: SKTexture!
    var arrowRightTexture: SKTexture!
    var arrowUpTexture: SKTexture!
    var arrowDownTexture: SKTexture!
    var bulletTexture: SKTexture!
    
    // Sprite Nodes
    var bg = SKSpriteNode()
    var plane = SKSpriteNode()
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    var badPlane = SKSpriteNode()
    var arrowRight = SKSpriteNode()
    var arrowUp = SKSpriteNode()
    var arrowDown = SKSpriteNode()
    var bullet = SKSpriteNode()
    
    var scoreLable = SKLabelNode()
    var hightScoreLable = SKLabelNode()
    //Sprite Object
    
    var bgObject = SKNode()
    var planeObject = SKNode()
    var groundObject = SKNode()
    var skyObject = SKNode()
    var badPlaneObject = SKNode()
    var arrowRightObject = SKNode()
    var arrowUpObject = SKNode()
    var arrowDownObject = SKNode()
    var bulletObject = SKNode()
    var lableObject = SKNode()
    
    // Bit mask
    var planeGroup: UInt32 = 0x1 << 1
    var groundGroup: UInt32 = 0x1 << 2
    var badPlaneGroup: UInt32 = 0x1 << 3
    var bulletGroup: UInt32 = 0x1 << 4
    
    // SKTextureArray for animate With Texture
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
                //timerAddBadPlane = Timer()
                timerForAddBadPlane()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        bgTexture = SKTexture(imageNamed: "BG.png")
        planeTexture = SKTexture(imageNamed: "Fly1.png")
        badPlaneTexture = SKTexture(imageNamed: "badFly1.png")
        arrowRightTexture = SKTexture(imageNamed: "right.png")
        arrowDownTexture = SKTexture(imageNamed: "down.png")
        arrowUpTexture = SKTexture(imageNamed: "up.npg")
        bulletTexture = SKTexture(imageNamed: "bullet1.png")
        self.physicsWorld.contactDelegate = self
        
        createObjects()
        createGame()
    }
    
    func createObjects() {
        self.addChild(bgObject)
        self.addChild(planeObject)
        self.addChild(groundObject)
        self.addChild(skyObject)
        self.addChild(badPlaneObject)
        self.addChild(arrowUpObject)
        self.addChild(arrowDownObject)
        self.addChild(arrowRightObject)
        self.addChild(bulletObject)
        self.addChild(lableObject)
    }
    
    func createGame() {
        createBg()
        //createGround()
        //createSky()
        createPlane()
        timerForAddBadPlane()
        addArrows()
        addScoreLable()
        addHightScoreLable()
        
    }
    
    func addScoreLable () {
        scoreLable.fontName = "score"
        scoreLable.text = "0"
        scoreLable.position = CGPoint(x: frame.maxX / 2, y: frame.maxY - 150)
        scoreLable.fontSize = 30
        scoreLable.fontColor = .white
        scoreLable.zPosition = 2
        lableObject.addChild(scoreLable)
    }
    func addHightScoreLable () {
        hightScoreLable.fontName = "score"
        hightScoreLable.text = "Hight score - 0"
        hightScoreLable.position = CGPoint(x: frame.maxX - 150, y: frame.maxY - 150)
        hightScoreLable.fontSize = 30
        hightScoreLable.fontColor = .white
        hightScoreLable.zPosition = 2
        lableObject.addChild(hightScoreLable)
    }
    
    func createBg() {
        bgTexture = SKTexture(imageNamed: "BG.png")
        
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 3)
        let replaceBg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg,replaceBg]))
        
        for i in 0...2 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: size.width/4 + (bgTexture.size().width - 1) * CGFloat(i), y: size.height/2)
            bg.size.height = self.frame.height
            bg.run(moveBgForever)
            bg.zPosition = -1
            
            
            bgObject.addChild(bg)
        }
    }/*
    func createGround() {
        ground = SKSpriteNode()
        ground.position = CGPoint(x: 0, y: 70)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 10))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundGroup
        
        groundObject.addChild(ground)
        
    }
    
    func createSky() {
        sky = SKSpriteNode()
        sky.position = CGPoint(x: 0, y: self.frame.maxY - 5)
        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.height, height: 10))
        sky.physicsBody?.isDynamic = false
        sky.zPosition = 1
        
        skyObject.addChild(sky)
 
    }*/
    
    
    func addPlane(planeNode: SKSpriteNode, atPosition position: CGPoint) {
        planeObject.removeAllChildren()
        plane = SKSpriteNode(texture: planeTexture)
    
        planeFlyTextureArray = [SKTexture(imageNamed: "Fly1.png"),SKTexture(imageNamed: "Fly2.png")]
        planeShootTextureArray = [SKTexture(imageNamed: "Shoot1.png"),SKTexture(imageNamed: "Shoot2.png"),SKTexture(imageNamed: "Shoot3.png"),SKTexture(imageNamed: "Shoot4.png"),SKTexture(imageNamed: "Shoot5.png")]
        let planeFlyAnimation = SKAction.animate(with: planeFlyTextureArray, timePerFrame: 0.1)
        let flyPlane = SKAction.repeatForever(planeFlyAnimation)
        plane.run(flyPlane)
        
        plane.position = position
        currentLocationY = position.y
        plane.size.height = 84
        plane.size.width = 120
        
        plane.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: plane.size.width - 40 , height: plane.size.height - 30))
        
        plane.physicsBody?.categoryBitMask = planeGroup
        plane.physicsBody?.contactTestBitMask = badPlaneGroup
        plane.physicsBody?.collisionBitMask = groundGroup
        
        plane.physicsBody?.isDynamic = true
        plane.physicsBody?.affectedByGravity = false
        //plane.physicsBody?.restitution = 0
        plane.physicsBody?.allowsRotation = false
        plane.zPosition = 1

        
        planeObject.removeAllChildren()
        planeObject.addChild(plane)
        
    }
    
    func createPlane() {
        addPlane(planeNode: plane, atPosition: CGPoint(x: self.size.width / 4, y: frame.maxY / 2))
    
    }
    
    @objc func addBadPlane() {
        badPlane = SKSpriteNode(texture: badPlaneTexture)
        
        badPlaneFlyTextureArray = [SKTexture(imageNamed: "badFly1.png"),SKTexture(imageNamed: "badFly2.png")]
        let badPlaneFlyAnimation = SKAction.animate(with: badPlaneFlyTextureArray, timePerFrame: 0.1)
        let badFlyPlane = SKAction.repeatForever(badPlaneFlyAnimation)
        
        badPlane.run(badFlyPlane)
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipOffset = CGFloat(movementAmount) - self.frame.height / 4
        
        
       
        badPlane.size.height = 42
        badPlane.size.width = 60
        
        badPlane.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: badPlane.size.width - 10 , height: badPlane.size.height - 8))
        badPlane.physicsBody?.restitution = 0
        badPlane.position = CGPoint(x: self.size.width + 50, y: badPlaneTexture.size().height + 98 + pipOffset)
        
        let moveBad = SKAction.moveBy(x: -self.frame.size.width, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let badMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveBad,removeAction]))
        
        badPlane.run(badMoveBgForever)
        badPlane.physicsBody?.isDynamic = false
        badPlane.physicsBody?.categoryBitMask = badPlaneGroup
        badPlane.zPosition = 1
        
        badPlaneObject.addChild(badPlane)
        
    }
    
    func timerForAddBadPlane() {
        timerAddBadPlane.invalidate()
        
        timerAddBadPlane = Timer.scheduledTimer(timeInterval: timeIntervalForCreate, target: self, selector: #selector(addBadPlane), userInfo: nil, repeats: true)
        
    }
    
    
    func addArrows() {
        arrowRight = SKSpriteNode(texture: arrowRightTexture)
        arrowDown = SKSpriteNode(texture: arrowDownTexture)
        arrowUp = SKSpriteNode(texture: arrowUpTexture)
        
        arrowRight.position = CGPoint(x: frame.maxX - 100, y: 150)
        
        arrowRight.physicsBody?.isDynamic = false
        arrowRight.zPosition = 2
        arrowRight.size.height = 105
        arrowRight.size.width = 150
        arrowRightObject.addChild(arrowRight)
        
        arrowDown.position = CGPoint(x: 50, y: 150)
        
        arrowDown.physicsBody?.isDynamic = false
        arrowDown.zPosition = 2
        arrowDown.size.height = 70
        arrowDown.size.width = 100
        arrowDownObject.addChild(arrowDown)
        
        arrowUp.position = CGPoint(x: 50, y: 250)
        
        arrowUp.physicsBody?.isDynamic = false
        arrowUp.zPosition = 2
        arrowUp.size.height = 70
        arrowUp.size.width = 100
        arrowUpObject.addChild(arrowUp)
    }
    
    func createBullet(position: CGPoint) {
        
        bullet = SKSpriteNode(texture: bulletTexture)
        
        bullet.size.height = 20
        bullet.size.width = 30
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20 , height: 30))
        
        bullet.position = position
        
        let moveBad = SKAction.moveBy(x: self.frame.size.width, y: 0, duration: 4)
        let removeAction = SKAction.removeFromParent()
        let badMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveBad,removeAction]))
        
        bullet.run(badMoveBgForever)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = bulletGroup
        bullet.physicsBody?.contactTestBitMask = badPlaneGroup
        bullet.zPosition = 1
        
        bulletObject.addChild(bullet)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
}
