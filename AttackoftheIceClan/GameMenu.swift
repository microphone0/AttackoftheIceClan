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
    let title = SKLabelNode(fontNamed: "Rockwell Bold")
    let play = SKSpriteNode(imageNamed: "play")
    let shop = SKSpriteNode(imageNamed: "shop")
    
    
    override func didMove(to view: SKView) {
        //Add background to center of the screen
        background.zPosition = 0
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        addChild(background)
        
        //Add title
        title.text = "Attack of the Ice Clan!"
        title.fontColor = UIColor.black
        title.fontSize = 40
        title.zPosition = 1
        title.position = CGPoint(x: frame.size.width/2, y: (frame.size.height/4)*3)
        addChild(title)
        
        //Add play button
        play.zPosition = 1
        play.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        addChild(play)
        
        //Add shop button
        shop.zPosition = 1
        shop.position = CGPoint(x: frame.size.width/2, y: frame.size.height/3)
        addChild(shop)
    }
}
