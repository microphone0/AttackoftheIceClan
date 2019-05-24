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
    
    private var defaults = UserDefaults.standard
    
    private var coins: Int?
    
    private var bullets: Int?
    
    private var bulletCost: Int?
    
    private var piercing: Int?
    
    private var piercingCost: Int?
    
    private var radius: Int?
    
    private var radiusCost: Int?
    
    // MARK: Methods
    
    // Had a bug where some variables weren't getting initialized so had to make init function
    init() {
        
        retrieveData()
        if (coins == 0 && piercingCost == 0 && bulletCost == 0 && radiusCost == 0) {
            coins = 0
            piercingCost = 50
            bulletCost = 50
            radiusCost = 50
            saveData()
        }
        
    }
    
    /** Retrieve data from persistent store */
    private func retrieveData() {
        
        coins = defaults.integer(forKey: "coins")
        bullets = defaults.integer(forKey: "bullets")
        bulletCost = defaults.integer(forKey: "bulletCost")
        piercing = defaults.integer(forKey: "piercing")
        piercingCost = defaults.integer(forKey: "piercingCost")
        radius = defaults.integer(forKey: "radius")
        radiusCost = defaults.integer(forKey: "radiusCost")
        
    }
    
    
    /** Save data for persistence */
    private func saveData() {
        
        defaults.set(coins, forKey: "coins")
        defaults.set(bullets, forKey: "bullets")
        defaults.set(bulletCost, forKey: "bulletCost")
        defaults.set(piercing, forKey: "piercing")
        defaults.set(piercingCost, forKey: "piercingCost")
        defaults.set(radius, forKey: "radius")
        defaults.set(radiusCost, forKey: "radiusCost")
        
    }
    
    // MARK: Getters
    
    // Get number of coins
    func coinCount() -> Int {
        
        retrieveData()
        if let coins = coins {
            return coins
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
    
    // Get cost for bullets
    func bulletCostCount() -> Int {
        
        retrieveData()
        if let bulletCost = bulletCost {
            return bulletCost
        } else {
            return 50
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
    
    // Get cost for piercing
    func piercingCostCount() -> Int {
        
        retrieveData()
        if let piercingCost = piercingCost {
            return piercingCost
        } else {
            return 50
        }
        
    }
    
    // Get number of radius that a bullet can affect
    func radiusCount() -> Int {
        
        retrieveData()
        if let radius = radius {
            return radius
        } else {
            return 0
        }
        
    }
    
    // Get cost for radius
    func radiusCostCount() -> Int {
        
        retrieveData()
        if let radiusCost = radiusCost {
            return radiusCost
        } else {
            return 50
        }
        
    }
    
    // MARK: Incrementers
    
    // Increment the player's amount of coins
    func incrementCoinCount() {
        
        coins = coinCount() + 1
        saveData()
        
    }
    
    /** Increment the player's number of bullets */
    func incrementBulletCount() {
        
        bullets = bulletCount() + 1
        saveData()
        
    }
    
    // Increment the player's amount of bullet cost
    func incrementBulletCostCount() {
        
        bulletCost = bulletCostCount() + 50
        saveData()
        
    }
    
    /** Increment the player's piercing ability */
    func incrementPiercingCount() {
        
        piercing = piercingCount() + 1
        saveData()
        
    }
    
    // Increment the player's amount of piercing cost
    func incrementPiercingCostCount() {
        
        piercingCost = piercingCostCount() + 50
        saveData()
        
    }
    
    // Increment the player's radius ability
    func incrementRadiusCount() {
        
        radius = radiusCount() + 1
        saveData()
        
    }
    
    // Increment the player's amount of piercing cost
    func incrementRadiusCostCount() {
        
        radiusCost = radiusCostCount() + 50
        saveData()
        
    }
    
    // MARK: Decrementers
    
    func decrementCoinCount( price: Int) {
        
        coins = coinCount() - price
        saveData()
        
    }
}
