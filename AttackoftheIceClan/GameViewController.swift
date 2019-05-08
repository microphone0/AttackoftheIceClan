//
//  GameViewController.swift
//  AttackoftheIceClan
//
//  Created by Adam Saxton on 4/22/19.
//  Copyright © 2019 Adam Saxton. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load next scene (Game Menu) then transition to it
        let scene = GameMenuScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
