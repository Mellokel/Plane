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
        
        if contact.bodyA.categoryBitMask == bulletBitMask && contact.bodyB.categoryBitMask == badPlaneBitMask || contact.bodyB.categoryBitMask == bulletBitMask && contact.bodyA.categoryBitMask == badPlaneBitMask {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            score += 1
            if score > hightScore {
                hightScore += 1
            }
            
        }
        if contact.bodyA.categoryBitMask == planeBitMask && contact.bodyB.categoryBitMask == badPlaneBitMask || contact.bodyB.categoryBitMask == planeBitMask && contact.bodyA.categoryBitMask == badPlaneBitMask {
            let badPlaneNode = contact.bodyA.categoryBitMask == badPlaneBitMask ? contact.bodyA.node : contact.bodyB.node
            badPlaneNode?.removeFromParent()
            
            plane.spriteNode.removeAllActions()
            
            plane.spriteNode.texture = SKTexture(imageNamed: "Dead.png")
            plane.spriteNode.physicsBody?.affectedByGravity = true
            plane.spriteNode.physicsBody?.contactTestBitMask = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.plane.spriteNode.removeFromParent()
                self.timeIntervalForCreate = 3
                self.score = 0
                
                self.createPlane()
                self.plane.spriteNode.physicsBody?.isDynamic = false
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    self.plane.spriteNode.physicsBody?.isDynamic = true
                })
                
            })
        }
        
    }
}
