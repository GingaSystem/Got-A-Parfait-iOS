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
        .Syrup : -10,
    ]
    
    // 各パーツがグラスに対して上から何pxの位置に描画されるべきかを調整する
    let offsetY : Dictionary<Kind, CGFloat> = [
        .Topping : 376,
        .TopIce : 1000,
        .Fruit : 1816,
        .BottomIce : 1896,
        .Syrup : 3096,
    ]
    
    // グラスの画像
    static private let glass = UIImage(named: "パフェグラス１.png")!
    
    static private let toppingRatio: CGFloat = 0.4
    static private let toppings = [
        ParfaitPart(.Topping, "棒クッキー１.png", toppingRatio, "awa.wav"),
        ParfaitPart(.Topping, "ミント１.png", toppingRatio, "hail.wav"),
        ParfaitPart(.Topping, "フレーク１.png", toppingRatio, "kaze.wav"),
        ParfaitPart(.Topping, "チョコスプレー１.png", toppingRatio, "mizu.wav"),
        ParfaitPart(.Topping, "さくらんぼ１.png", toppingRatio, "mizu.wav"),
        // ParfaitPart(.Topping, "ハートクッキー１.png", toppingRatio, "kirakira8.wav"),
    ]
    
    static private let topIceRatio: CGFloat = 0.82
    static private let topIces = [
        ParfaitPart(.TopIce, "バニラアイス１.png", topIceRatio, "counter5.wav"),
        ParfaitPart(.TopIce, "レモンアイス１.png", topIceRatio, "counter4.wav"),
        ParfaitPart(.TopIce, "チョコアイス１.png", topIceRatio, "counter1.wav"),
        ParfaitPart(.TopIce, "プリン１.png", topIceRatio, "counter3.wav"),
        ParfaitPart(.TopIce, "マカロン１.png", topIceRatio, "counter2.wav"),
        // ParfaitPart(.TopIce, "ベリーアイス１.png", topIceRatio, "counter5.wav"),
    ]
    
    static private let fruitRatio: CGFloat = 0.72
    static private let fruits =  [
        ParfaitPart(.Fruit, "レモン１.png", fruitRatio, "backing2.wav"),
        ParfaitPart(.Fruit, "オレンジ１.png", fruitRatio, "backing5.wav"),
        ParfaitPart(.Fruit, "メロン１.png", fruitRatio, "backing2.wav"),
        ParfaitPart(.Fruit, "いちご１.png", fruitRatio, "backing3.wav"),
        ParfaitPart(.Fruit, "ぶどう１.png", fruitRatio, "backing4.wav"),
    ]
    
    static private let bottomIceRatio: CGFloat = 0.43
    static private let bottomIces = [
        ParfaitPart(.BottomIce, "赤系１.png", bottomIceRatio, "bass3.wav"),
        ParfaitPart(.BottomIce, "オレンジ系１.png", bottomIceRatio, "bass4_1.wav"),
        ParfaitPart(.BottomIce, "マカロン系１.png", bottomIceRatio, "bass3_1.wav"),
        ParfaitPart(.BottomIce, "ホッピングシャワー系１.png", bottomIceRatio, "bass2.wav"),
        ParfaitPart(.BottomIce, "紫１.png", bottomIceRatio, "bass1.wav"),
    ]
    
    static private let syrupRatio: CGFloat = 0.5
    static private let syrups = [
        ParfaitPart(.Syrup, "ピンク系１.png", syrupRatio, "drum5_1.wav"),
        ParfaitPart(.Syrup, "緑系１.png", syrupRatio, "drum2_1.wav"),
        ParfaitPart(.Syrup, "青系１.png", syrupRatio, "drum3_1.wav"),
        ParfaitPart(.Syrup, "紫系１.png", syrupRatio, "drum1_1.wav"),
        ParfaitPart(.Syrup, "モカ系１.png", syrupRatio, "drum4_1.wav"),
    ]
    
    static private var nextId: Int = 0
    
    static private var mapping : Dictionary<Int, ParfaitPart> = [:]
    
    // パーツのID番号
    let id : Int
    
    // パーツの種類
    let kind : Kind
    
    // パーツの画像
    let image : UIImage
    
    // パーツの画像のグラスに対する大きさの比
    let imageRatio : CGFloat
    
    // パーツに対応するトラックの名前
    let trackURL : URL
    
    private init(_ kind: Kind, _ imageName : String, _ imageRatio: CGFloat, _ trackPath: String){
        self.id = ParfaitPart.nextId
        self.kind = kind
        self.image = UIImage(named: imageName)!
        self.imageRatio = imageRatio
        self.trackURL = Bundle.main.bundleURL.appendingPathComponent(trackPath)
        
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
        let h = self.image.size.height * ratio * self.imageRatio
        let w = self.image.size.width * ratio * self.imageRatio
        let x = ((glassSize.width - w + offsetX[self.kind]!) / 2.0)
        let y = offsetY[self.kind]! * ratio
        return CGRect(x: x, y: y, width: w, height: h)
    }
}
