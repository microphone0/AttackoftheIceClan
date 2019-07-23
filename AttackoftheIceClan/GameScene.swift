//
//  GameScene.swift
//  AttackoftheIceClan
//
//  Created by Adam Saxton on 4/22/19.
//  Copyright © 2019 Adam Saxton. All rights reserved.
//

import SpriteKit

// MARK: Struct and Dictionaries

struct PhysicsCategory {
    
    static let none       : UInt32 = 0
    static let all        : UInt32 = UInt32.max
    static let iceBullet  : UInt32 = 0b1
    static let projectile : UInt32 = 0b10
    static let radius     : UInt32 = 0b101
    
}

// MARK: Extension of class

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
        
        // Contact between iceBullet and projectile
        if (firstBody.node?.name == "iceBullet") && ((secondBody.node?.name?.contains("projectile")) ?? false) {
            if ((firstBody.categoryBitMask & PhysicsCategory.iceBullet != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
                if let iceBullet = firstBody.node as? SKSpriteNode,
                    let projectile = secondBody.node as? SKSpriteNode {
                    projectileDidCollideWithIceBullet(projectile: projectile, iceBullet: iceBullet)
                }
            }
        }
        
        // Contact between radius and iceBullet
        if (firstBody.node?.name == "iceBullet") && ((secondBody.node?.name!.contains("radius")) ?? false) {
            if ((firstBody.categoryBitMask & PhysicsCategory.iceBullet != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.radius != 0)) {
                if let iceBullet = firstBody.node as? SKSpriteNode,
                    let radius = secondBody.node as? SKSpriteNode {
                    radiusDidCollideWithIceBullet(radius: radius, iceBullet: iceBullet)
                }
            }
        }
    }
    
}

// MARK: Math functions for CGPoint

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

// MARK: Class

class GameScene: SKScene {
    
    // Initialize variables
    let player = SKSpriteNode(imageNamed: "fireMage")
    var background = SKSpriteNode(imageNamed: "background")
    var coins: SKLabelNode!
    var projectileName = "projectile"
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    let upgrade = Upgrade()
    var score = 0
    
    // Used a dictionary to store how much piercing each bullet has (if any), also declare it without anything in it since no bullets have been made at this point
    var bulletDict: Dictionary<String?, Int> = [:]
    
    // Used to spawn more enemies
    var scoreTracker = 10
    var extraEnemy = 5
    
    override func didMove(to view: SKView) {
        
        // Set the background
        background.zPosition = 0
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        addChild(background)
        
        // Add the player
        player.zPosition = 1
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        addChild(player)
        
        // Set the physics
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addIceBullet),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        // Add music
        let backgroundMusic = SKAudioNode(fileNamed: "Komiku_Battle_of_Pogs.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        // Add coins label
        coins = SKLabelNode(fontNamed: "Chalkduster")
        coins.zPosition = 1
        coins.text = "Coins: \(upgrade.coinCount())"
        coins.fontColor = UIColor.black
        coins.fontSize = 30
        coins.position = CGPoint(x: 160, y: size.height*0.9)
        addChild(coins)
        
        // Add score label
        scoreLabel.zPosition = 1
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontColor = UIColor.black
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height*0.9)
        addChild(scoreLabel)
        
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
        
        iceBullet.physicsBody = SKPhysicsBody(rectangleOf: iceBullet.size)
        iceBullet.physicsBody?.isDynamic = true
        iceBullet.physicsBody?.categoryBitMask = PhysicsCategory.iceBullet
        iceBullet.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        iceBullet.physicsBody?.collisionBitMask = PhysicsCategory.none
        iceBullet.name = "iceBullet"
        
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
    
    // MARK: Touch handler
    
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
        projectile.name = "projectile\(random())"
        
        // Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // Bail out if you are shooting too far down or backwards
        if offset.x < -100 { return }
        
        // OK to add now - you've double checked position
        addChild(projectile)
        bulletDict.updateValue(upgrade.piercingCount(), forKey: projectile.name!)
        
        // Get the direction of where to shoot
        let direction = offset.normalized()
        
        // Rotate projectile to make it look nicer
        let mathStuff = offset.y/offset.x
        if (atan(mathStuff) < 0) {
            projectile.zRotation = atan(mathStuff)*CGFloat.pi
        } else {
            projectile.zRotation = atan(mathStuff)
        }
        
        // Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * size.width
        
        // Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 1.0)
        let actionMoveDone = SKAction.removeFromParent()
        let actionRemoveDict = SKAction.run {
            self.bulletDict.removeValue(forKey: projectile.name)
        }
        projectile.run(SKAction.sequence([actionMove, actionMoveDone, actionRemoveDict]))
        
        var changeInDirection = true
        var up = false
        var down = false
        
        // Used to make the bullet span more the more that's added
        // Has to be type casted to CGFloat, so the math can be done with it
        var span = CGFloat(50)
        
        // If user has purchased bullet count upgrades then add the extra bullets when the player shoots
        if upgrade.bulletCount() > 0 {
            let numBullet = upgrade.bulletCount()
            
            for _ in 1...numBullet {
                // Load the projectile
                let projectile2 = SKSpriteNode(imageNamed: "fireball")
                
                // Set up the bullet
                projectile2.zPosition = 2
                projectile2.position = player.position
                projectile2.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
                projectile2.physicsBody?.isDynamic = true
                projectile2.physicsBody?.categoryBitMask = PhysicsCategory.projectile
                projectile2.physicsBody?.contactTestBitMask = PhysicsCategory.iceBullet
                projectile2.physicsBody?.collisionBitMask = PhysicsCategory.none
                projectile2.physicsBody?.usesPreciseCollisionDetection = true
                projectile2.name = "projectile\(random())"
                
                // Add the projectile
                addChild(projectile2)
                bulletDict.updateValue(upgrade.piercingCount(), forKey: projectile2.name!)
                
                // Find new the offset of the second bullet
                var offset2 = touchLocation - projectile.position
                
                // If making a bullet above the center one
                if changeInDirection {
                    offset2.y += span
                    offset2.x -= span
                    
                    changeInDirection = false
                    up = true
                }
                // If making a bullet below the center one
                else {
                    offset2.y -= span
                    offset2.x += span
                    
                    changeInDirection = true
                    down = true
                }
                
                // Get the direction of the second bullet
                let direction2 = offset2.normalized()
                let mathStuff2 = direction2.y/direction2.x
                
                // If the angle is negative flip it, so the rotation can be set up correctly
                if (atan(mathStuff2) < 0) {
                    projectile2.zRotation = atan(mathStuff2)*CGFloat.pi
                } else {
                    projectile2.zRotation = atan(mathStuff2)
                }
                
                // Set up the rest of the variables to allow the second bullet to shoot in the right direction
                let shootAmount2 = direction2 * size.width
                let realDest2 = shootAmount2 + projectile2.position
                let actionMove = SKAction.move(to: realDest2, duration: 1.0)
                let actionMoveDone = SKAction.removeFromParent()
                let actionRemoveDict = SKAction.run {
                    self.bulletDict.removeValue(forKey: projectile2.name)
                }
                projectile2.run(SKAction.sequence([actionMove, actionMoveDone, actionRemoveDict]))
                
                // If a bullet has spawned on both sides of the center bullet increase span so more bullets will appear
                if up && down {
                    span += 50
                    up = false
                    down = false
                }
            }
        }
        
    }
    
    func projectileDidCollideWithIceBullet(projectile: SKSpriteNode, iceBullet: SKSpriteNode) {
        
        if(bulletDict[projectile.name] ?? 0 > 0) {
            bulletDict[projectile.name]! -= 1
        } else {
            projectile.removeFromParent()
            bulletDict.removeValue(forKey: projectile.name)
        }
        iceBullet.removeFromParent()
        
        // Load radius into scene
        let radius = SKSpriteNode(imageNamed: "fireArea")
        radius.zPosition = 2
        radius.position = projectile.position
        let radiusSize = radius.size.width+CGFloat(upgrade.radiusCount()*2)
        radius.size.width = radiusSize
        radius.size.height = radiusSize
        radius.physicsBody = SKPhysicsBody(circleOfRadius: radiusSize/2)
        radius.physicsBody?.isDynamic = true
        radius.physicsBody?.categoryBitMask = PhysicsCategory.radius
        radius.physicsBody?.contactTestBitMask = PhysicsCategory.iceBullet
        radius.physicsBody?.collisionBitMask = PhysicsCategory.none
        radius.physicsBody?.usesPreciseCollisionDetection = true
        radius.name = "radius\(random())"
        addChild(radius)
        
        upgrade.incrementCoinCount()
        score = score + 1
        coins.text = "Coins: \(upgrade.coinCount())"
        scoreLabel.text = "Score: \(score)"
        
        // If amount of iceBullets is equal to n then spawn a bunch at once
        // MAKE THIS INTO A SEPARATE FUNCTION
        if score == scoreTracker {
            for _ in 1...extraEnemy {
                addIceBullet()
            }
            scoreTracker += 20
            extraEnemy += 10
        }
        
    }
    
    func radiusDidCollideWithIceBullet(radius: SKSpriteNode, iceBullet: SKSpriteNode) {
        
        // Remove nodes from scene
        radius.removeFromParent()
        iceBullet.removeFromParent()
        
        // Increases score and coin count
        upgrade.incrementCoinCount()
        score = score + 1
        coins.text = "Coins: \(upgrade.coinCount())"
        scoreLabel.text = "Score: \(score)"
        
        // Can still trigger mass spawn
        if score == scoreTracker {
            for _ in 1...extraEnemy {
                addIceBullet()
            }
            scoreTracker += 20
            extraEnemy += 10
        }
        
    }
    
}
