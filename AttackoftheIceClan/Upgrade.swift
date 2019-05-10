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
    
    // MARK: Properties
    
    private var piercing: Int?
    
    private var bullets: Int?
    
    private var defaults = UserDefaults.standard
    
    private var coins: Int?
    
    private var bulletCost: Int?
    
    private var piercingCost: Int? 
    
    // MARK: Methods
    
    // Had a bug where some variables weren't getting initialized so had to make init function
    init() {
        
        retrieveData()
        if (coins == 0 && bulletCost == 0 && piercingCost == 0) {
            coins = 0
            bulletCost = 50
            piercingCost = 50
            saveData()
        }
        
    }
    
    /** Retrieve data from persistent store */
    private func retrieveData() {
        
        piercing = defaults.integer(forKey: "piercing")
        bullets = defaults.integer(forKey: "bullets")
        coins = defaults.integer(forKey: "coins")
        bulletCost = defaults.integer(forKey: "bulletCost")
        piercingCost = defaults.integer(forKey: "piercingCost")
        
    }
    
    
    /** Save data for persistence */
    private func saveData() {
        
        defaults.set(piercing, forKey: "piercing")
        defaults.set(bullets, forKey: "bullets")
        defaults.set(coins, forKey: "coins")
        defaults.set(bulletCost, forKey: "bulletCost")
        defaults.set(piercingCost, forKey: "piercingCost")
        
    }
    
    // MARK: Getters
    
    /** Get number of bullets that can be shot at once */
    func bulletCount() -> Int {
        
        retrieveData()
        if let bullets = bullets {
            return bullets
        } else {
            return 0
        }
        
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
    
    // Get number of coins that can be shot at once
    func coinCount() -> Int {
        
        retrieveData()
        if let coins = coins {
            return coins
        } else {
            return 0
        }
        
    }
    
    // Get number of coins that can be shot at once
    func bulletCostCount() -> Int {
        
        retrieveData()
        if let bulletCost = bulletCost {
            return bulletCost
        } else {
            return 50
        }
        
    }
    
    // Get number of coins that can be shot at once
    func piercingCostCount() -> Int {
        
        retrieveData()
        if let piercingCost = piercingCost {
            return piercingCost
        } else {
            return 50
        }
        
    }
    
    // MARK: Incrementers
    
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
    
    // Increment the player's amount of coins
    func incrementCoinCount(gameplayCoins: Int) {
        
        coins = coinCount() + gameplayCoins
        saveData()
        
    }
    
    // Increment the player's amount of coins
    func incrementBulletCostCount() {
        
        bulletCost = bulletCostCount() + 50
        saveData()
        
    }
    
    // Increment the player's amount of coins
    func incrementPiercingCostCount() {
        
        piercingCost = piercingCostCount() + 50
        saveData()
        
    }
    
}
