//
//  GameScenePhysics.swift
//  Plane
//
//  Created by Admin on 25.04.18.
//  Copyright © 2018 Разработчик. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == bulletGroup && contact.bodyB.categoryBitMask == badPlaneGroup || contact.bodyB.categoryBitMask == bulletGroup && contact.bodyA.categoryBitMask == badPlaneGroup {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            score += 1
            if score > hightScore {
                hightScore += 1
            }
            
        }
        if contact.bodyA.categoryBitMask == planeGroup && contact.bodyB.categoryBitMask == badPlaneGroup || contact.bodyB.categoryBitMask == planeGroup && contact.bodyA.categoryBitMask == badPlaneGroup {
            let badPlaneNode = contact.bodyA.categoryBitMask == badPlaneGroup ? contact.bodyA.node : contact.bodyB.node
            badPlaneNode?.removeFromParent()
            let planeNode = contact.bodyA.categoryBitMask == planeGroup ? contact.bodyA.node : contact.bodyB.node
            planeNode?.removeAllActions()
            plane.texture = SKTexture(imageNamed: "Dead.png")
            plane.physicsBody?.affectedByGravity = true
            self.plane.physicsBody?.contactTestBitMask = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                planeNode?.removeFromParent()
                self.timeIntervalForCreate = 3
                self.score = 0
                
                self.createPlane()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    self.plane.physicsBody?.contactTestBitMask = self.badPlaneGroup
                })
                
            })
        }
        
    }
}
