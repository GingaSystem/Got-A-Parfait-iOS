//
//  PafaitClasses.swift
//  parfait_scroll
//
//  Created by Oka Ayumi on 2019/09/15.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import UIKit

class ParfaitPart{
    //パーツのひとつずつのクラス
    
    enum Kind {
        case Topping
        case TopIce
        case Fruit
        case BottomIce
        case Syrup
    }
    
    static private let toppings = [
        ParfaitPart(.Topping, "Topping1","tr1"),
        ParfaitPart(.Topping, "Topping2","tr1"),
        ParfaitPart(.Topping, "Topping3","tr1"),
        ParfaitPart(.Topping, "Topping4","tr1"),
        ParfaitPart(.Topping, "Topping5","tr1"),]
    
    static private let topIces = [
        ParfaitPart(.TopIce, "TopIce1","tr1"),
        ParfaitPart(.TopIce, "TopIce2","tr1"),
        ParfaitPart(.TopIce, "TopIce3","tr1"),
        ParfaitPart(.TopIce, "TopIce4","tr1"),
        ParfaitPart(.TopIce, "TopIce5","tr1"),
        ]
    
    static private let fruits =  [
        ParfaitPart(.Fruit, "Fruits1","tr1"),
        ParfaitPart(.Fruit, "Fruits2","tr1"),
        ParfaitPart(.Fruit, "Fruits3","tr1"),
        ParfaitPart(.Fruit, "Fruits4","tr1"),
        ParfaitPart(.Fruit, "Fruits5","tr1"),
        ]
    
    static private let bottomIces = [
        ParfaitPart(.BottomIce, "BottomIce1","tr1"),
        ParfaitPart(.BottomIce, "BottomIce2","tr1"),
        ParfaitPart(.BottomIce, "BottomIce3","tr1"),
        ParfaitPart(.BottomIce, "BottomIce4","tr1"),
        ParfaitPart(.BottomIce, "BottomIce5","tr1"),
        ]
    
    static private let syrups = [
        ParfaitPart(.Syrup, "Syrup1","tr1"),
        ParfaitPart(.Syrup, "Syrup2","tr1"),
        ParfaitPart(.Syrup, "Syrup3","tr1"),
        ParfaitPart(.Syrup, "Syrup4","tr1"),
        ParfaitPart(.Syrup, "Syrup5","tr1"),
        ]
    
    static private var nextId: Int = 0
    
    static private var mapping : Dictionary<Int, ParfaitPart> = [:]
    
    let id : Int
    let kind : Kind
    let image : UIImage
    let trackName : String
    
    private init(_ kind: Kind, _ imageName : String, _ trackName: String){
        self.id = ParfaitPart.nextId
        self.kind = kind
        self.image = UIImage(named: imageName)!
        self.trackName = trackName
        
        ParfaitPart.nextId += 1
        ParfaitPart.mapping[self.id] = self
    }
    
    static func getToppings() -> [ParfaitPart]{
        return toppings
    }
    
    static func getTopIces() -> [ParfaitPart]{
        return topIces
    }
    
    static func getFruits() -> [ParfaitPart]{
        return fruits
    }
    
    static func getBottomIces() -> [ParfaitPart]{
        return bottomIces
    }
    
    static func getSyrups() -> [ParfaitPart]{
        return syrups
    }
    
    static func getPartByID(_ id : Int) -> ParfaitPart {
        return ParfaitPart.mapping[id]!
    }
}
