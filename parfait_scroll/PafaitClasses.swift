//
//  PafaitClasses.swift
//  parfait_scroll
//
//  Created by Oka Ayumi on 2019/09/15.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import UIKit

class PafaitPart{//パーツのひとつずつのクラス
    
    let partImage : UIImage
    let partTrack : String
    
    init(imageName : String, trackName: String){
        partImage = UIImage(named: imageName)!
        partTrack = trackName
        
    }
    
}
