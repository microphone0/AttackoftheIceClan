//
//  GameMenu.swift
//  AttackoftheIceClan
//
//  Created by Adam Saxton on 4/26/19.
//  Copyright © 2019 Adam Saxton. All rights reserved.
//

import Foundation
import SpriteKit

class GameMenuScene: SKScene {
    let background = SKSpriteNode(imageNamed: "SplashBack")
    
    override func didMove(to view: SKView) {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        view.presentScene(gameScene, transition: reveal)
    }
}
