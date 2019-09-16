//
//  PafaitClasses.swift
//  parfait_scroll
//
//  Created by Oka Ayumi on 2019/09/15.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import UIKit

class ParfaitPart{//パーツのひとつずつのクラス
    
    let partImage : UIImage
    let partTrack : String
    
    init(_ imageName : String, _ trackName: String){
        partImage = UIImage(named: imageName)!
        partTrack = trackName
    }
    
    static func getToppings() -> [ParfaitPart]{
        return [ParfaitPart("Topping1","tr1"),
                ParfaitPart("Topping2","tr1"),
                ParfaitPart("Topping3","tr1"),
                ParfaitPart("Topping4","tr1"),
                ParfaitPart("Topping5","tr1")]
    }
    
    static func getTopIces() -> [ParfaitPart]{
        return [ParfaitPart("TopIce1","tr1"),
                ParfaitPart("TopIce2","tr1"),
                ParfaitPart("TopIce3","tr1"),
                ParfaitPart("TopIce4","tr1"),
                ParfaitPart("TopIce5","tr1")]
    }
    
    static func getFruits() -> [ParfaitPart]{
        return [ParfaitPart("Fruits1","tr1"),
                ParfaitPart("Fruits2","tr1"),
                ParfaitPart("Fruits3","tr1"),
                ParfaitPart("Fruits4","tr1"),
                ParfaitPart("Fruits5","tr1")]
    }
    
    static func getBottomIces() -> [ParfaitPart]{
        return [ParfaitPart("BottomIce1","tr1"),
                ParfaitPart("BottomIce2","tr1"),
                ParfaitPart("BottomIce3","tr1"),
                ParfaitPart("BottomIce4","tr1"),
                ParfaitPart("BottomIce5","tr1")]
    }
    
    static func getSyrups() -> [ParfaitPart]{
        return [ParfaitPart("Syrup1","tr1"),
                ParfaitPart("Syrup2","tr1"),
                ParfaitPart("Syrup3","tr1"),
                ParfaitPart("Syrup4","tr1"),
                ParfaitPart("Syrup5","tr1")]
    }
}


