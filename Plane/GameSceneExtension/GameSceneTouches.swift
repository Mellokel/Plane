//
//  GameSceneTouches.swift
//  Plane
//
//  Created by Разработчик on 25.04.18.
//  Copyright © 2018 Разработчик. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard plane.spriteNode.physicsBody?.contactTestBitMask != 0 else { return }
        for touch in touches {
            let location = touch.location(in: self)
            if arrowRight.objectNode.contains(location) && !gameIsPaused {
                let planeShootAnimation = SKAction.animate(with: planeShootTextureArray, timePerFrame: 0.1)
                //let planeFlyAnimation = SKAction.animate(with: planeFlyTextureArray, timePerFrame: 0.1)
                //let planeFlyAnimationRepeat = SKAction.repeatForever(planeFlyAnimation)
                
                plane.spriteNode.run(SKAction.sequence([planeShootAnimation]))
                createBullet(position: CGPoint(x: plane.objectNode.position.x + self.size.width / 4 + 30, y: currentLocationY - 20))
                continue
            }
            
            if plane.objectNode.contains(location) && !gameIsPaused {
                currentLocationY = location.y
                plane.spriteNode.run(SKAction.moveTo(y: currentLocationY, duration: 0.2))
                continue
            }
            gameIsPaused = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard plane.spriteNode.physicsBody?.contactTestBitMask != 0 && !gameIsPaused else { return }
        for touch in touches {
            let location = touch.location(in: self)
            plane.spriteNode.run(SKAction.moveTo(y: currentLocationY, duration: 0.2))
            currentLocationY = location.y
        }
    }
}
