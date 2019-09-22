//
//  ViewController.swift
//  parfait_scroll
//
//  Created by Oka Ayumi on 2019/08/10.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import UIKit
import AVFoundation
import Accounts

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerScroll: UIScrollView!
    @IBOutlet weak var pickerScrollContentView: UIView!
    @IBOutlet weak var glass: UIImageView!
    @IBOutlet weak var glassContents: UIImageView!
    @IBOutlet weak var spoon: UIImageView!
    
    // ドラッグされているパーツ
    var partsBeingDragged: ParfaitPart!
    
    // 現在選択されているパーツ
    var currentParts: Dictionary<ParfaitPart.Kind, ParfaitPart> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // パーツ選択スクロールのセットアップ
        setupPickerScrollContentView()
        pickerScroll.isPagingEnabled = true
        
        // グラスにパーツをドラッグしたときの動作を定義する
        let interaction = UIDropInteraction(delegate: self)
        glassContents.addInteraction(interaction)
        glassContents.isUserInteractionEnabled = true
        
        // 共有ボタン
        spoon.isUserInteractionEnabled = true
        spoon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.spoonTapped(_:))))
        
        // 初期状態の設定
        currentParts[.Syrup] = ParfaitPart.getSyrups()[0]
        currentParts[.BottomIce] = ParfaitPart.getBottomIces()[0]
        currentParts[.Fruit] = ParfaitPart.getFruits()[0]
        currentParts[.TopIce] = ParfaitPart.getTopIces()[0]
        currentParts[.Topping] = ParfaitPart.getToppings()[0]
        refreshGlassContents()
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
    
    func createPickerPage(parts : [ParfaitPart]) -> UIView {
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
    
    @objc func spoonTapped(_ sender: UITapGestureRecognizer) {
        print("spoon tapped")
        shareParfait()
    }
    
    func refreshGlassContents() {
        let img = drawGlassContents()
        glassContents.image = img
        previewTrack(parts: currentParts)
    }

    func shareParfait() {
        // パフェを共有する
        
        // オーディオトラック作成
        let (audioURL, trackLength) = renderTrack(parts: currentParts)
        
        // ビデオトラック作成
        renderVideo(
            image: drawGlassAndContents(
                contentSize: CGSize(width: 952, height: 1600),
                glassSize: CGSize(width: 952, height: 1230)),
            length: trackLength,
            cb: {
                (videoURL: URL) -> Void in
                print("movie located at", videoURL)
                
                // 共有用のミックス動画の作成
                renderMixed(audioURL, videoURL, {
                    (assetExport) -> Void in
                    if assetExport.status == AVAssetExportSession.Status.failed {
                        // 失敗した場合
                        print("mix failed:", assetExport.error!)
                    } else if assetExport.status == AVAssetExportSession.Status.completed {
                        // 成功した場合
                        print("mix completed")
                        
                        DispatchQueue.main.async {
                            let activityVC = UIActivityViewController(activityItems: [getMixedVideoURL()], applicationActivities: nil)
                            activityVC.popoverPresentationController!.sourceView = self.glass
                            self.present(activityVC, animated: true, completion: nil)
                        }
                    }
                })
            })
    }
    
    func drawGlassAndContents(contentSize: CGSize, glassSize: CGSize) -> UIImage {
        let entireRegionRect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        let glassRegionRect = CGRect(x: 0, y: contentSize.height - glassSize.height, width: glassSize.width, height: glassSize.height)
        
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        UIRectFill(entireRegionRect)
        self.glass.image!.draw(in: glassRegionRect)
        drawGlassContents(contentSize: contentSize, glassSize: glassSize).draw(in: CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
         let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    func drawGlassContents(contentSize: CGSize? = nil, glassSize: CGSize? = nil) -> UIImage {
        let targetContentSize = contentSize == nil ? self.glassContents.frame.size : contentSize
        let targetGlassSize = glassSize == nil ? self.glass.frame.size : glassSize

        UIGraphicsBeginImageContextWithOptions(targetContentSize!, false, 0)
        for kind: ParfaitPart.Kind in [.Syrup, .BottomIce, .Fruit, .TopIce, .Topping] {
            guard let part = currentParts[kind] else { continue }
            let rect = part.getRectRelativeToGlass(glassSize: targetGlassSize!)
            part.image.draw(in: rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
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
