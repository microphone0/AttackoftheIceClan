//
//  GameScene.swift
//  AttackoftheIceClan
//
//  Created by Adam Saxton on 4/22/19.
//  Copyright © 2019 Adam Saxton. All rights reserved.
//

import SpriteKit

//MARK: Struct

struct PhysicsCategory {
    
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let iceBullet   : UInt32 = 0b1
    static let projectile: UInt32 = 0b10
    
}

// Used to spawn more enemies
var n = 30
// Used to make the bullet span more the more that's added
// Has to be type casted to CGFloat, so the math can be done with it
var span = CGFloat(50)

//MARK: Extension of class

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.iceBullet != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let iceBullet = firstBody.node as? SKSpriteNode,
                let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithIceBullet(projectile: projectile, iceBullet: iceBullet)
            }
        }
        
    }
    
}

//MARK: Math functions for CGPoint

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

//MARK: Extension of CGPoint

extension CGPoint {
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
    
}

//MARK: Class

class GameScene: SKScene {
    
    // Initialize variables
    let player = SKSpriteNode(imageNamed: "fireMage")
    var background = SKSpriteNode(imageNamed: "background")
    var iceBulletDestroyed = 0
    var score: SKLabelNode!
    
    let upgrade = Upgrade()
    
    override func didMove(to view: SKView) {
        
        background.zPosition = 0
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        addChild(background)
        
        player.zPosition = 1
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        addChild(player)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addIceBullet),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        let backgroundMusic = SKAudioNode(fileNamed: "Komiku_Battle_of_Pogs.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        score = SKLabelNode(fontNamed: "Chalkduster")
        score.zPosition = 1
        score.text = "Score: \(iceBulletDestroyed)"
        score.fontColor = UIColor.black
        score.fontSize = 30
        score.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        addChild(score)
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addIceBullet() {
        
        // Create sprite
        let iceBullet = SKSpriteNode(imageNamed: "iceBall")
        
        iceBullet.physicsBody = SKPhysicsBody(rectangleOf: iceBullet.size) // 1
        iceBullet.physicsBody?.isDynamic = true // 2
        iceBullet.physicsBody?.categoryBitMask = PhysicsCategory.iceBullet // 3
        iceBullet.physicsBody?.contactTestBitMask = PhysicsCategory.projectile // 4
        iceBullet.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        
        // Determine where to spawn the iceBullet along the Y axis
        let actualY = random(min: iceBullet.size.height/2, max: size.height - iceBullet.size.height/2)
        
        // Position the iceBullet slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        iceBullet.zPosition = 2
        iceBullet.position = CGPoint(x: size.width + iceBullet.size.width/2, y: actualY)
        
        // Add the iceBullet to the scene
        addChild(iceBullet)
        
        // Determine speed of the iceBullet
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.5))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -iceBullet.size.width/2, y: actualY),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        let loseAction = SKAction.run() { [weak self] in
            guard let `self` = self else { return }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        iceBullet.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
    }
    
    //MARK: Touch handler
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        
        run(SKAction.playSoundFileNamed("Fireball+2.wav", waitForCompletion: false))
        
        let touchLocation = touch.location(in: self)
        
        // Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "fireball")
        projectile.zPosition = 2
        projectile.position = player.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.iceBullet
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // Bail out if you are shooting down or backwards
        if offset.x < 0 { return }
        
        // OK to add now - you've double checked position
        addChild(projectile)
        
        // Get the direction of where to shoot
        let direction = offset.normalized()
        
        //Rotate projectile to make it look nicer
        let mathStuff = offset.y/offset.x
        projectile.zRotation = atan(mathStuff)
        
        // Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 1.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        var changeInDirection = true
        var positive = false
        var negative = false
        // If user has purchased bullet count upgrades then add the extra bullets when the player shoots
        if upgrade.bulletCount() > 0 {
            let numBullet = upgrade.bulletCount()
            
            for _ in 1...numBullet {
                // Positive change in direction
                if changeInDirection {
                    let touchLocation2 = touch.location(in: self)
                    let projectile2 = SKSpriteNode(imageNamed: "fireball")
                    projectile2.zPosition = 2
                    projectile2.position = player.position
                    
                    projectile2.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
                    projectile2.physicsBody?.isDynamic = true
                    projectile2.physicsBody?.categoryBitMask = PhysicsCategory.projectile
                    projectile2.physicsBody?.contactTestBitMask = PhysicsCategory.iceBullet
                    projectile2.physicsBody?.collisionBitMask = PhysicsCategory.none
                    projectile2.physicsBody?.usesPreciseCollisionDetection = true
                    addChild(projectile2)
                    
                    var offset2 = touchLocation2 - projectile2.position
                    offset2.y = offset2.y + span
                    offset2.x = offset2.x + span
                    let direction2 = offset2.normalized()
                    let mathstuff2 = direction2.y/direction2.x
                    // If the angle is negative flip it, so the rotation can be set up correctly
                    if (atan(mathstuff2) < 0) {
                        projectile2.zRotation = atan(mathstuff2)*CGFloat.pi
                    } else {
                        projectile2.zRotation = atan(mathstuff2)
                    }
                    let shootAmount2 = direction2 * 1000
                    let realDest2 = shootAmount2 + projectile2.position
                    let actionMove = SKAction.move(to: realDest2, duration: 1.0)
                    let actionMoveDone = SKAction.removeFromParent()
                    projectile2.run(SKAction.sequence([actionMove, actionMoveDone]))
                    
                    changeInDirection = false
                    positive = true
                }
                // Negative change in direction
                else {
                    let touchLocation2 = touch.location(in: self)
                    let projectile2 = SKSpriteNode(imageNamed: "fireball")
                    projectile2.zPosition = 2
                    projectile2.position = player.position
                    
                    projectile2.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
                    projectile2.physicsBody?.isDynamic = true
                    projectile2.physicsBody?.categoryBitMask = PhysicsCategory.projectile
                    projectile2.physicsBody?.contactTestBitMask = PhysicsCategory.iceBullet
                    projectile2.physicsBody?.collisionBitMask = PhysicsCategory.none
                    projectile2.physicsBody?.usesPreciseCollisionDetection = true
                    addChild(projectile2)
                    
                    var offset2 = touchLocation2 - projectile2.position
                    offset2.y = offset2.y - span
                    offset2.x = offset2.x - span
                    let direction2 = offset2.normalized()
                    let mathstuff2 = direction2.y/direction2.x
                    // If the angle is negative flip it, so the rotation can be set up correctly
                    if (atan(mathstuff2) < 0) {
                        projectile2.zRotation = atan(mathstuff2)*CGFloat.pi
                    } else {
                        projectile2.zRotation = atan(mathstuff2)
                    }
                    let shootAmount2 = direction2 * 1000
                    let realDest2 = shootAmount2 + projectile2.position
                    let actionMove = SKAction.move(to: realDest2, duration: 1.0)
                    let actionMoveDone = SKAction.removeFromParent()
                    projectile2.run(SKAction.sequence([actionMove, actionMoveDone]))
                    
                    changeInDirection = true
                    negative = true
                }
            }
            
            // If a bullet has spawned on both sides of the center bullet increase span so more bullets will appear
            if positive && negative {
                span += 50
                positive = false
                negative = false
            }
        }
        
    }
    
    func projectileDidCollideWithIceBullet(projectile: SKSpriteNode, iceBullet: SKSpriteNode) {
        
        projectile.removeFromParent()
        iceBullet.removeFromParent()
        
        iceBulletDestroyed += 1
        score.text = "Score: \(iceBulletDestroyed)"
        
        //If amount of iceBullets is equal to n then spawn a bunch at once
        if iceBulletDestroyed == n {
            //Uncomment 3 lines below for win transition
            //let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            //let gameOverScene = GameOverScene(size: self.size, won: true)
            //view?.presentScene(gameOverScene, transition: reveal)
            for _ in 1...5 {
                addIceBullet()
            }
            n += 30
        }
        
    }
    
}
