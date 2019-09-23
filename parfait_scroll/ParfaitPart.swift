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
    private static let defaultOffsetX : Dictionary<Kind, CGFloat> = [
        .Topping : 30,
        .TopIce : 0,
        .Fruit : 0,
        .BottomIce : -8,
        .Syrup : -4,
    ]
    
    // 各パーツがグラスに対して下から何pxの位置に描画されるべきかを調整する
    private static let defaultOffsetY : Dictionary<Kind, CGFloat> = [
        .Topping : 4500,
        .TopIce : 4700,
        .Fruit : 3750,
        .BottomIce : 3340,
        .Syrup : 1650,
    ]
    
    // グラスの画像
    static private let glass = UIImage(named: "パフェグラス１.png")!
    
    static private let toppings = [
        ParfaitPart(.Topping, "棒クッキー１.png", 0.6, "awa.wav", offsetX: 100),
        ParfaitPart(.Topping, "ハートクッキー１.png", 0.5, "kirakira8.wav", offsetX: -120, offsetY: -700),
        ParfaitPart(.Topping, "ミント１.png", 1.0, "hail.wav", offsetX: 80, offsetY: -600),
        ParfaitPart(.Topping, "マカロン１.png", 0.6, "counter2.wav", offsetX: -120, offsetY: -700),
        ParfaitPart(.Topping, "さくらんぼ１.png", 0.6, "mizu.wav", offsetX: 80, offsetY: -300),
        ParfaitPart(.Topping, "チョコスプレー１.png", 0.9, "mizu.wav",offsetX: -20, offsetY: -800),
        ParfaitPart(.Topping, "フレーク１.png", 0.4, "kaze.wav", offsetX: -100, offsetY: -500),
        
    ]
    
    static private let topIces = [
        ParfaitPart(.TopIce, "バニラアイス１.png", 1.0, "counter5.wav"),
        ParfaitPart(.TopIce, "チョコアイス１.png", 1.0, "counter1.wav", offsetY: -20),
        ParfaitPart(.TopIce, "ベリーアイス１.png", 0.8, "counter5.wav", offsetY: 100),
        ParfaitPart(.TopIce, "プリン１.png", 1.0, "counter3.wav", offsetY: -100),
        ParfaitPart(.TopIce, "レモンアイス１.png", 1.0, "counter4.wav"),
    ]
    
    static private let fruits =  [
        ParfaitPart(.Fruit, "レモン１.png", 1.0, "backing2.wav"),
        ParfaitPart(.Fruit, "オレンジ１.png", 1.0, "backing5.wav", offsetY: 200),
        ParfaitPart(.Fruit, "メロン１.png", 0.95, "backing2.wav", offsetY: 200),
        ParfaitPart(.Fruit, "いちご１.png", 0.8, "backing3.wav"),
        ParfaitPart(.Fruit, "ぶどう１.png", 0.9, "backing4.wav"),
    ]
    
    static private let bottomIceRatio: CGFloat = 0.47
    static private let bottomIces = [
        ParfaitPart(.BottomIce, "赤系１.png", bottomIceRatio, "bass11.wav"),
        ParfaitPart(.BottomIce, "オレンジ系１.png", bottomIceRatio, "bass12.wav"),
        ParfaitPart(.BottomIce, "マカロン系１.png", bottomIceRatio, "bass13.wav"),
        ParfaitPart(.BottomIce, "ホッピングシャワー系１.png", bottomIceRatio, "bass14.wav"),
        ParfaitPart(.BottomIce, "紫１.png", bottomIceRatio, "bass1.wav"),
    ]
    
    static private let syrupRatio: CGFloat = 0.5
    static private let syrups = [
        ParfaitPart(.Syrup, "ピンク系１.png", syrupRatio, "drum1.wav"),
        ParfaitPart(.Syrup, "緑系１.png", syrupRatio, "drum2.wav"),
        ParfaitPart(.Syrup, "青系１.png", syrupRatio, "drum3.wav"),
        ParfaitPart(.Syrup, "紫系１.png", syrupRatio, "drum4.wav"),
        ParfaitPart(.Syrup, "モカ系１.png", syrupRatio, "drum5.wav"),
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
    
    // 画像のオフセット
    let offsetX : CGFloat
    let offsetY : CGFloat
    
    // パーツに対応するトラックの名前
    let trackURL : URL
    
    private init(
            _ kind: Kind, _ imageName : String, _ imageRatio: CGFloat, _ trackPath: String,
            offsetX: CGFloat = 0, offsetY: CGFloat = 0){
        self.id = ParfaitPart.nextId
        self.kind = kind
        self.image = UIImage(named: imageName)!
        self.imageRatio = imageRatio
        self.trackURL = Bundle.main.bundleURL.appendingPathComponent(trackPath)
        self.offsetX = ParfaitPart.defaultOffsetX[kind]! + offsetX
        self.offsetY = ParfaitPart.defaultOffsetY[kind]! + offsetY
        
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
    
    func getRectRelativeToGlass(glassSize actualGlassSize : CGSize, parfaitMargin: CGFloat) -> CGRect {
        let originalGlassHeight = ParfaitPart.glass.size.height
        let ratio = actualGlassSize.height / originalGlassHeight
        let h = self.image.size.height * ratio * self.imageRatio
        let w = self.image.size.width * ratio * self.imageRatio
        let x = ((actualGlassSize.width - w + self.offsetX) / 2.0)
        let y = parfaitMargin + (originalGlassHeight - self.offsetY) * ratio
        return CGRect(x: x, y: y, width: w, height: h)
    }
}
