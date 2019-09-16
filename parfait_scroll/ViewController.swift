//
//  ViewController.swift
//  parfait_scroll
//
//  Created by Oka Ayumi on 2019/08/10.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerScroll: UIScrollView!
    @IBOutlet weak var pickerScrollContentView: UIView!
    @IBOutlet weak var glass: UIImageView!
    @IBOutlet weak var glassContents: UIImageView!
    
    // ドラッグされているパーツ
    var partsBeingDragged: ParfaitPart!
    
    // 現在選択されているパーツ
    var currentParts: Dictionary<ParfaitPart.Kind, ParfaitPart> = [:]
    var players: [AVAudioPlayer] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // パーツ選択スクロールのセットアップ
        setupPickerScrollContentView()
        pickerScroll.isPagingEnabled = true
        
        // グラスにパーツをドラッグしたときの動作を定義する
        let interaction = UIDropInteraction(delegate: self)
        glass.addInteraction(interaction)
        glass.isUserInteractionEnabled = true
    }
    
    func setupPickerScrollContentView() {
        let contentView = pickerScrollContentView!
        let stack = UIStackView()
        contentView.addSubview(stack)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            stack.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        
        let allParts = [ParfaitPart.getSyrups(),
                        ParfaitPart.getBottomIces(),
                        ParfaitPart.getFruits(),
                        ParfaitPart.getTopIces(),
                        ParfaitPart.getToppings(),
        ]
        allParts.forEach {
            let pageView = createPickerPage(parts: $0)
            stack.addArrangedSubview(pageView)
            pageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pageView.widthAnchor.constraint(equalTo: pickerScroll.widthAnchor),
                pageView.heightAnchor.constraint(equalTo: pickerScroll.heightAnchor),
                ])
        }
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: pickerScroll.widthAnchor, multiplier: CGFloat(allParts.count))
            ])
    }
    
    func createPickerPage(parts : [ParfaitPart])->UIView{
        let pageView = UIView()
        
        let stackV:UIStackView = UIStackView()
        pageView.addSubview(stackV)
        stackV.axis = .vertical
        stackV.distribution = .fillEqually
        stackV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackV.widthAnchor.constraint(equalTo: pageView.widthAnchor),
            stackV.heightAnchor.constraint(equalTo: pageView.heightAnchor),
            ])
        
        let stackH1:UIStackView = UIStackView()
        let stackH2:UIStackView = UIStackView()
        func setupStackH(_ stack: UIStackView) {
            stackV.addArrangedSubview(stack)
            stack.axis = .horizontal
            stack.frame = CGRect(x: 0, y: 0, width: stackV.frame.width, height: stackV.frame.height / 2)
            stack.distribution = .fillEqually
        }
        setupStackH(stackH1)
        setupStackH(stackH2)
        
        func createPartsImageView(_ part: ParfaitPart) -> UIImageView {
            let img = UIImageView(image: part.image)
            img.isOpaque = false
            img.backgroundColor = .clear
            img.contentMode = .scaleAspectFit
            img.tag = part.id
            
            let interaction = UIDragInteraction(delegate: self)
            interaction.isEnabled = true
            img.addInteraction(interaction)
            img.isUserInteractionEnabled = true
            return img
        }
        
        let firstRowCount = parts.count / 2 + parts.count % 2
        for i in 0..<firstRowCount {
            stackH1.addArrangedSubview(createPartsImageView(parts[i]))
        }
        for i in firstRowCount..<parts.count {
            stackH2.addArrangedSubview(createPartsImageView(parts[i]))
        }
        
        return pageView
    }
    
    func refreshGlassContents() {
        print("New parts set")
        let img = drawGlassContents()
        glassContents.image = img
        for kind: ParfaitPart.Kind in [.Syrup, .BottomIce, .Fruit, .TopIce, .Topping] {
            guard let part = currentParts[kind] else { continue }
            let url = Bundle.main.bundleURL.appendingPathComponent(part.trackName)
            var player:AVAudioPlayer!
            do {
                try player = AVAudioPlayer(contentsOf:url)
                
                
                //音楽をバッファに読み込んでおく
                player.prepareToPlay()
                
            } catch {
                print(error)
            }
            players.append(player)
            player.play()
        }
        
    }
    
    func drawGlassContents() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.glass.frame.size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        for kind: ParfaitPart.Kind in [.Syrup, .BottomIce, .Fruit, .TopIce, .Topping] {
            guard let part = currentParts[kind] else { continue }
            let rect = part.getRectRelativeToGlass(glassSize: glassContents.frame.size)
            ctx!.draw(part.image.cgImage!, in: rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
}

extension ViewController : UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let part = ParfaitPart.getPartByID(interaction.view!.tag)
        self.partsBeingDragged = part
        return [UIDragItem(itemProvider: NSItemProvider(object: part.image))]
    }
}

extension ViewController : UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let part = self.partsBeingDragged!
        self.currentParts[part.kind] = part
        self.refreshGlassContents()
    }
}
