//
//  Player.swift
//  AttackoftheIceClan
//
//  Created by Adam Saxton on 5/1/19.
//  Copyright © 2019 Adam Saxton. All rights reserved.
//


//  Credit to Tendaishe Gwini for help with this code

import Foundation

class Upgrade {
    
    //MARK: Properties
    
    private var piercing: Int?
    
    private var bullets: Int?
    
    private var defaults = UserDefaults.standard
    
    //MARK: Methods
    
    /** Retrieve data from persistent store */
    private func retrieveData() {
        
        piercing = defaults.integer(forKey: "piercing")
        bullets = defaults.integer(forKey: "bullets")
        
    }
    
    
    /** Save data for persistence */
    private func saveData() {
        
        defaults.set(piercing, forKey: "piercing")
        defaults.set(bullets, forKey: "bullets")
        
    }
    
    
    /** Get number of enemies that can be hit with one bullet */
    func piercingCount() -> Int {
        
        retrieveData()
        if let piercing = piercing {
            return piercing
        } else {
            return 0
        }
        
    }
    
    /** Get number of bullets that can be shot at once */
    func bulletCount() -> Int {
        
        retrieveData()
        if let bullets = bullets {
            return bullets
        } else {
            return 0
        }
        
    }
    
    /** Increment the player's number of bullets */
    func incrementBulletCount() {
        
        bullets = bulletCount() + 1
        saveData()
        
    }
    
    /** Increment the player's piercing ability */
    func incrementPiercingCount() {
        
        piercing = piercingCount() + 1
        saveData()
        
    }
    
    
    
    
    
}
