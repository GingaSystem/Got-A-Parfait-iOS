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
    
    let partImage : UIImage
    let partTrack : String
    
    init(_ imageName : String, _ trackName: String){
        partImage = UIImage(named: imageName)!
        partTrack = trackName
    }
    
    static func getToppings() -> [ParfaitPart]{
        return [ParfaitPart("Topping1","se_maoudamashii_effect01.mp3"),
                ParfaitPart("Topping2","se_maoudamashii_effect02.mp3"),
                ParfaitPart("Topping3","se_maoudamashii_effect03.mp3"),
                ParfaitPart("Topping4","se_maoudamashii_effect04.mp3"),
                ParfaitPart("Topping5","se_maoudamashii_effect05.mp3")]
    }
    
    static func getTopIces() -> [ParfaitPart]{
        return [ParfaitPart("TopIce1","se_maoudamashii_effect10.mp3"),
                ParfaitPart("TopIce2","se_maoudamashii_effect06.mp3"),
                ParfaitPart("TopIce3","se_maoudamashii_effect07.mp3"),
                ParfaitPart("TopIce4","se_maoudamashii_effect08.mp3"),
                ParfaitPart("TopIce5","se_maoudamashii_effect09.mp3")]
    }
    
    static func getFruits() -> [ParfaitPart]{
        return [ParfaitPart("Fruits1","se_maoudamashii_effect12.mp3"),
                ParfaitPart("Fruits2","se_maoudamashii_effect11.mp3"),
                ParfaitPart("Fruits3","se_maoudamashii_effect13.mp3"),
                ParfaitPart("Fruits4","se_maoudamashii_effect14.mp3"),
                ParfaitPart("Fruits5","se_maoudamashii_effect15.mp3")]
    }
    
    static func getBottomIces() -> [ParfaitPart]{
        return [ParfaitPart("BottomIce1","se_maoudamashii_effect05.mp3"),
                ParfaitPart("BottomIce2","se_maoudamashii_effect04.mp3"),
                ParfaitPart("BottomIce3","se_maoudamashii_effect03.mp3"),
                ParfaitPart("BottomIce4","se_maoudamashii_effect02.mp3"),
                ParfaitPart("BottomIce5","se_maoudamashii_effect01.mp3")]
    }
    
    static func getSyrups() -> [ParfaitPart]{
        return [ParfaitPart("Syrup1","se_maoudamashii_effect06.mp3"),
                ParfaitPart("Syrup2","se_maoudamashii_effect07.mp3"),
                ParfaitPart("Syrup3","se_maoudamashii_effect08.mp3"),
                ParfaitPart("Syrup4","se_maoudamashii_effect09.mp3"),
                ParfaitPart("Syrup5","se_maoudamashii_effect10.mp3")]
    }
}


