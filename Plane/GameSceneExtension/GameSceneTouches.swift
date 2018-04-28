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
        
        /**/
        
        guard plane.physicsBody?.contactTestBitMask != 0 else { return }
        for touch in touches {
            let location = touch.location(in: self)
            if arrowRightObject.contains(location) {
                let planeShootAnimation = SKAction.animate(with: planeShootTextureArray, timePerFrame: 0.1)
                let planeFlyAnimation = SKAction.animate(with: planeFlyTextureArray, timePerFrame: 0.1)
                let planeFlyAnimationRepeat = SKAction.repeatForever(planeFlyAnimation)
                
                plane.run(SKAction.sequence([planeShootAnimation,planeFlyAnimationRepeat]))
                createBullet(position: CGPoint(x: planeObject.position.x + self.size.width / 4 + 30, y: currentLocationY - 20))
                continue
            }
            
            if planeObject.contains(location) {
                currentLocationY = location.y
                plane.run(SKAction.moveTo(y: currentLocationY, duration: 0.2))
                continue
            }
            if arrowUpObject.contains(touch.location(in: self)) {
                guard planeObject.position.y < frame.size.height / 2 - 200 else {return}
                planeObject.position.y += 50
                continue
            }
            
            if arrowDownObject.contains(touch.location(in: self)) {
                guard planeObject.position.y > -frame.size.height / 2 + 200 else { return }
                planeObject.position.y -= 50
                continue
            }
        }
        //plane.physicsBody?.velocity = CGVector.zero
        //plane.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard plane.physicsBody?.contactTestBitMask != 0 else { return }
        for touch in touches {
            let location = touch.location(in: self)
            //if planeObject.contains(location) {
            
                plane.run(SKAction.moveTo(y: currentLocationY, duration: 0.2))
                currentLocationY = location.y
            //}
        }
    }
}
