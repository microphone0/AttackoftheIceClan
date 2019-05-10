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
    let numBulletButton = SKSpriteNode(imageNamed: "buy")
    let piercingButton = SKSpriteNode(imageNamed: "buy")
    let backButton = SKSpriteNode(imageNamed: "back")
    
    let title = SKLabelNode(text: " ")
    let numBulletLabel = SKLabelNode(text: " ")
    let piercingLabel = SKLabelNode(text: " ")
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        // MARK: Adding to scene
        
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
        
        // Add text for the number of piercing upgrade
        title.text = "Welcome the Fiery Bazaar!"
        title.zPosition = 1
        title.fontName = "Rockwell Bold"
        title.fontSize = 30
        title.position = CGPoint(x: (size.width/2), y: size.height-60)
        addChild(title)
        
        // Add text for the number of bullets upgrade
        numBulletLabel.text = "Purchase additional bullets? \(upgradeManger.bulletCostCount()) Coins"
        numBulletLabel.zPosition = 1
        numBulletLabel.fontName = "Rockwell Bold"
        numBulletLabel.fontSize = 25
        numBulletLabel.position = CGPoint(x: (size.width/3), y: ((size.height/3)*2)-40)
        addChild(numBulletLabel)
        
        // Button to purchase more bullets
        numBulletButton.zPosition = 1
        numBulletButton.size = CGSize(width: 100, height: 50)
        numBulletButton.position = CGPoint(x: ((size.width/3)*2)+100, y: ((size.height/3)*2)-30)
        addChild(numBulletButton)
        
        // Add text for the number of piercing upgrade
        piercingLabel.text = "Purchase the piering upgrade? \(upgradeManger.piercingCostCount()) Coins"
        piercingLabel.zPosition = 1
        piercingLabel.fontName = "Rockwell Bold"
        piercingLabel.fontSize = 25
        piercingLabel.position = CGPoint(x: (size.width/3), y: (size.height/3)-40)
        addChild(piercingLabel)
        
        // Button to purchase more piercing
        piercingButton.zPosition = 1
        piercingButton.size = CGSize(width: 100, height: 50)
        piercingButton.position = CGPoint(x: ((size.width/3)*2)+100, y: (size.height/3)-30)
        addChild(piercingButton)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the location of touch event
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        
        // Check if touch event is in the back button
        if backButton.contains(touchLocation!) {
            
        }
        
        // Check if touch event is in the buy button for bullets
        if numBulletButton.contains(touchLocation!) {
           
        }
        
        // Check if touch event is in the buy button for piercing
        if piercingButton.contains(touchLocation!) {
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
