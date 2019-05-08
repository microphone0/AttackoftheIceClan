//
//  GameOverScene.swift
//  AttackoftheIceClan
//
//  Created by Adam Saxton on 4/22/19.
//  Copyright © 2019 Adam Saxton. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    // MARK: Initialize variables
    
    // Initialize background and buttons
    let playAgain = SKSpriteNode(imageNamed: "playAgain")
    let mainMenu = SKSpriteNode(imageNamed: "mainMenu")
    let background = SKSpriteNode(imageNamed: "gameOverBackground")
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        // Set the background
        background.zPosition = -1
        background.size.width = size.width
        background.size.height = size.height
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        // Set display message based on if player won or lost
        let message = won ? "You have defeated the Ice Clan!" : "The Ice Clan has won. :("
        
        // Set a label to the messsage
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: (size.height/4)*3)
        addChild(label)
        
        // Add "Play Again?" button
        playAgain.zPosition = 1
        playAgain.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(playAgain)
        
        // Add "Main Menu" button
        mainMenu.zPosition = 1
        mainMenu.position = CGPoint(x: size.width/2, y: size.height/3)
        addChild(mainMenu)
        
    }
    
    // MARK: Touch handler
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get location of touch event
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        
        // Check if touch location is in the play again button
        if playAgain.contains(touchLocation!) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = GameScene(size: (self.view?.bounds.size)!)
            self.view?.presentScene(scene, transition:reveal)
        }
        
        // Check if touch location is in the main menu button
        if mainMenu.contains(touchLocation!) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = GameMenuScene(size: (self.view?.bounds.size)!)
            self.view?.presentScene(scene, transition:reveal)
        }
        
    }
    
    // Run error if something happens requiring init
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
