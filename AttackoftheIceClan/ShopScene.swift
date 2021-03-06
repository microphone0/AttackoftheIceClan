//
//  ShopScene.swift
//  AttackoftheIceClan
//
//  Created by Adam Saxton on 4/30/19.
//  Copyright © 2019 Adam Saxton. All rights reserved.
//

import Foundation
import SpriteKit


class ShopScene: SKScene {
    
    // MARK: Initialize variables
    
    // Intialize background, button, text, and Upgrade manager
    let upgradeManger = Upgrade()
    
    let background = SKSpriteNode(imageNamed: "shopBackground")
    
    let backButton = SKSpriteNode(imageNamed: "back")
    let numBulletButton = SKSpriteNode(imageNamed: "buy")
    let piercingButton = SKSpriteNode(imageNamed: "buy")
    let radiusButton = SKSpriteNode(imageNamed: "buy")
    
    let title = SKLabelNode(fontNamed: "Rockwell Bold")
    let coinCount = SKLabelNode(fontNamed: "Rockwell Bold")
    let numBulletLabel = SKLabelNode(fontNamed: "Rockwell Bold")
    let bulletCount = SKLabelNode(fontNamed: "Rockwell Bold")
    let piercingLabel = SKLabelNode(fontNamed: "Rockwell Bold")
    let piercingCount = SKLabelNode(fontNamed: "Rockwell Bold")
    let radiusLabel = SKLabelNode(fontNamed: "Rockwell Bold")
    let radiusCount = SKLabelNode(fontNamed: "Rockwell Bold")
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        // MARK: Adding to scene
        
        
        upgradeManger.incrementCoinCount()
        
        // Add background image
        background.zPosition = -1
        background.size = CGSize(width: size.width, height: size.height)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        // Add back button
        backButton.zPosition = 1
        backButton.size = CGSize(width: 50, height: 50)
        backButton.position = CGPoint(x: 60, y: size.height-60)
        addChild(backButton)
        
        // Added title
        title.text = "Welcome the Fiery Bazaar!"
        title.zPosition = 1
        title.fontSize = 30
        title.position = CGPoint(x: (size.width/2), y: size.height-60)
        addChild(title)
        
        // Add text for the number of coins
        coinCount.text = "Coins: \(upgradeManger.coinCount())"
        coinCount.zPosition = 1
        coinCount.fontSize = 27
        coinCount.position = CGPoint(x: (size.width/2), y: size.height-100)
        addChild(coinCount)
        
        
        
        // Add text for the number of bullets upgrade
        numBulletLabel.text = "Purchase additional bullets? \(upgradeManger.bulletCostCount()) Coins"
        numBulletLabel.zPosition = 1
        numBulletLabel.fontSize = 25
        numBulletLabel.position = CGPoint(x: (size.width/3)-10, y: ((size.height/3)*2)-40)
        addChild(numBulletLabel)
        
        // Add text to let the user know how many upgrades they've bought
        bulletCount.text = "Number of bullets: \(upgradeManger.bulletCount())"
        bulletCount.zPosition = 1
        bulletCount.fontSize = 20
        bulletCount.position = CGPoint(x: (size.width/3)-149, y: ((size.height/3)*2)-70)
        addChild(bulletCount)
        
        // Button to purchase more bullets
        numBulletButton.zPosition = 1
        numBulletButton.size = CGSize(width: 100, height: 50)
        numBulletButton.position = CGPoint(x: ((size.width/3)*2)+100, y: ((size.height/3)*2)-30)
        addChild(numBulletButton)
        
        
        
        // Add text for the number of piercing upgrade
        piercingLabel.text = "Purchase the piering upgrade? \(upgradeManger.piercingCostCount()) Coins"
        piercingLabel.zPosition = 1
        piercingLabel.fontSize = 25
        piercingLabel.position = CGPoint(x: (size.width/3)+05, y: (size.height/2)-40)
        addChild(piercingLabel)
        
        // Add text to let the user know how many upgrades they've bought
        piercingCount.text = "Number of piercing upgrades: \(upgradeManger.piercingCount())"
        piercingCount.zPosition = 1
        piercingCount.fontSize = 20
        piercingCount.position = CGPoint(x: (size.width/3)-90, y: (size.height/2)-70)
        addChild(piercingCount)
        
        // Button to purchase more piercing
        piercingButton.zPosition = 1
        piercingButton.size = CGSize(width: 100, height: 50)
        piercingButton.position = CGPoint(x: ((size.width/3)*2)+100, y: (size.height/2)-30)
        addChild(piercingButton)
        
        
        
        // Add text for the number of radius upgrade
        if upgradeManger.radiusCount() == 0 {
            radiusLabel.text = "Purchase the radius upgrade? \(upgradeManger.radiusCostCount()) Coins"
            radiusLabel.zPosition = 1
            radiusLabel.fontSize = 25
            radiusLabel.position = CGPoint(x: (size.width/3), y: (size.height/3)-40)
        } else {
            radiusLabel.text = "Increase radius? \(upgradeManger.radiusCostCount()) Coins"
            radiusLabel.zPosition = 1
            radiusLabel.fontSize = 25
            radiusLabel.position = CGPoint(x: (size.width/3)-71, y: (size.height/3)-40)
        }
        addChild(radiusLabel)
        
        // Add text to let the user know how many upgrades they've bought
        radiusCount.text = "Number of radius upgrades: \(upgradeManger.radiusCount())"
        radiusCount.zPosition = 1
        radiusCount.fontSize = 20
        radiusCount.position = CGPoint(x: (size.width/3)-100, y: (size.height/3)-70)
        addChild(radiusCount)
        
        // Button to purchase more radius
        radiusButton.zPosition = 1
        radiusButton.size = CGSize(width: 100, height: 50)
        radiusButton.position = CGPoint(x: ((size.width/3)*2)+100, y: (size.height/3)-30)
        addChild(radiusButton)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the location of touch event
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        
        // Check if touch event is in the back button
        if backButton.contains(touchLocation!) {
            let reveal = SKTransition.flipHorizontal(withDuration: 1.0)
            let scene = GameMenuScene(size: size)
            self.view?.presentScene(scene, transition:reveal)
        }
        
        // Check if touch event is in the buy button for bullets
        if numBulletButton.contains(touchLocation!) {
            if upgradeManger.coinCount() >= upgradeManger.bulletCostCount() {
                
                // Update all the labels if user has enough coins and upgrade the bullet count
                upgradeManger.incrementBulletCount()
                upgradeManger.decrementCoinCount(price: upgradeManger.bulletCostCount())
                upgradeManger.incrementBulletCostCount()
                numBulletLabel.text = "Purchase additional bullets? \(upgradeManger.bulletCostCount()) Coins"
                numBulletLabel.position.x = (size.width/3)
                bulletCount.text = "Number of bullets: \(upgradeManger.bulletCount())"
                coinCount.text = "Coins: \(upgradeManger.coinCount())"
            }
        }
        
        // Check if touch event is in the buy button for piercing
        if piercingButton.contains(touchLocation!) {
            if upgradeManger.coinCount() >= upgradeManger.piercingCostCount() {
                // Update all the labels if user has enough coins and upgrade the piercing
                upgradeManger.incrementPiercingCount()
                upgradeManger.decrementCoinCount(price: upgradeManger.piercingCostCount())
                upgradeManger.incrementPiercingCostCount()
                piercingLabel.text = "Purchase the piercing upgrade? \(upgradeManger.piercingCostCount()) Coins"
                piercingCount.text = "Number of piercing upgrade: \(upgradeManger.piercingCount())"
                coinCount.text = "Coins: \(upgradeManger.coinCount())"
            }
        }
        
        // Check if touch event is in the buy button for radius
        if radiusButton.contains(touchLocation!) {
            if upgradeManger.coinCount() >= upgradeManger.radiusCostCount() {
                // Update all the labels if user has enough coins and upgrade the piercing
                upgradeManger.incrementRadiusCount()
                upgradeManger.decrementCoinCount(price: upgradeManger.radiusCostCount())
                upgradeManger.incrementRadiusCostCount()
                radiusLabel.text = "Increase radius? \(upgradeManger.radiusCostCount()) Coins"
                radiusLabel.position.x = (size.width/3)-71
                radiusCount.text = "Number of radius upgrade: \(upgradeManger.radiusCount())"
                coinCount.text = "Coins: \(upgradeManger.coinCount())"
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
