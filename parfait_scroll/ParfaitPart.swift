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
    
    // 各パーツが中央に対してX軸方向に何pxの位置に描画されるべきかを調整する
    let offsetX : Dictionary<Kind, CGFloat> = [
        .Topping : 30,
        .TopIce : 0,
        .Fruit : 0,
        .BottomIce : 0,
        .Syrup : 0,
        ]
    
    // 各パーツがグラスに対して上から何pxの位置に描画されるべきかを調整する
    let offsetY : Dictionary<Kind, CGFloat> = [
        .Topping : 0,
        .TopIce : 40,
        .Fruit : 180,
        .BottomIce : 280,
        .Syrup : 470,
        ]
    
    // グラスの画像
    static private let glass = UIImage(named: "Glass")!
    
    static private let toppings = [
        ParfaitPart(.Topping, "Topping1","awa.wav"),
        ParfaitPart(.Topping, "Topping2","kirakira2.m4a"),
        ParfaitPart(.Topping, "Topping3","kaze.wav"),
        ParfaitPart(.Topping, "Topping4","hail.wav"),
        ParfaitPart(.Topping, "Topping5","mizu.wav"),
        ]
    
    static private let topIces = [
        ParfaitPart(.TopIce, "TopIce1","counter3.wav"),
        ParfaitPart(.TopIce, "TopIce2","counter2.wav"),
        ParfaitPart(.TopIce, "TopIce3","counter1.wav"),
        ParfaitPart(.TopIce, "TopIce4","counter4.wav"),
        ParfaitPart(.TopIce, "TopIce5","counter5.wav"),
        ]
    
    static private let fruits =  [
        ParfaitPart(.Fruit, "Fruits1","backing2.wav"),
        ParfaitPart(.Fruit, "Fruits2","backing2.wav"),
        ParfaitPart(.Fruit, "Fruits3","backing3.wav"),
        ParfaitPart(.Fruit, "Fruits4","backing4.wav"),
        ParfaitPart(.Fruit, "Fruits5","backing5.wav"),
        ]
    
    static private let bottomIces = [
        ParfaitPart(.BottomIce, "BottomIce1","bass1.wav"),
        ParfaitPart(.BottomIce, "BottomIce2","bass3.wav"),
        ParfaitPart(.BottomIce, "BottomIce3","bass3_1.wav"),
        ParfaitPart(.BottomIce, "BottomIce4","bass4_1.wav"),
        ParfaitPart(.BottomIce, "BottomIce5","bass2.wav"),
        ]
    
    static private let syrups = [
        ParfaitPart(.Syrup, "Syrup1","drum1_1.wav"),
        ParfaitPart(.Syrup, "Syrup2","drum2_1.wav"),
        ParfaitPart(.Syrup, "Syrup3","drum3_1.wav"),
        ParfaitPart(.Syrup, "Syrup4","drum4_1.wav"),
        ParfaitPart(.Syrup, "Syrup5","drum5_1.wav"),
        ]
    
    static private var nextId: Int = 0
    
    static private var mapping : Dictionary<Int, ParfaitPart> = [:]
    
    // パーツのID番号
    let id : Int
    
    // パーツの種類
    let kind : Kind
    
    // パーツの画像
    let image : UIImage
    
    // パーツに対応するトラックの名前
    let trackName : String
    
    private init(_ kind: Kind, _ imageName : String, _ trackName: String){
        self.id = ParfaitPart.nextId
        self.kind = kind
        self.image = UIImage(named: imageName)!
        self.trackName = trackName
        
        ParfaitPart.nextId += 1
        ParfaitPart.mapping[self.id] = self
    }
    
    static func getToppings() -> [ParfaitPart] {
        return toppings
    }
    
    static func getTopIces() -> [ParfaitPart] {
        return topIces
    }
    
    static func getFruits() -> [ParfaitPart] {
        return fruits
    }
    
    static func getBottomIces() -> [ParfaitPart] {
        return bottomIces
    }
    
    static func getSyrups() -> [ParfaitPart] {
        return syrups
    }
    
    static func getPartByID(_ id : Int) -> ParfaitPart {
        return ParfaitPart.mapping[id]!
    }
    
    func getRectRelativeToGlass(glassSize : CGSize) -> CGRect {
        let ratio = glassSize.height / ParfaitPart.glass.size.height
        let h = self.image.size.height * ratio
        let w = self.image.size.width * ratio
        let x = ((glassSize.width - w + offsetX[self.kind]!) / 2.0)
        let y = offsetY[self.kind]! * ratio
        return CGRect(x: x, y: y, width: w, height: h)
    }
}
