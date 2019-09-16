//
//  ViewController.swift
//  parfait_scroll
//
//  Created by Oka Ayumi on 2019/08/10.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController{
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    var player:AVAudioPlayer!
    var player2:AVAudioPlayer!
    let url = Bundle.main.bundleURL.appendingPathComponent("parfaitMusicSample.mp3")
     let url2 = Bundle.main.bundleURL.appendingPathComponent("roma.mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //音楽パート
        do {
            try player = AVAudioPlayer(contentsOf:url)
            try player2 = AVAudioPlayer(contentsOf:url2)
            
            
            //音楽をバッファに読み込んでおく
            player.prepareToPlay()
            player2.prepareToPlay()
            
        } catch {
            print(error)
        }
    
        // パーツ選択スクロールのセットアップ
        setupScrollContentView()
        scroll.isPagingEnabled = true
    }

    
    @IBAction func playMusic(_ sender: UIButton) {
        
         player.play()
    }
    @IBAction func playMusic2(_ sender: UIButton) {
        
        player2.play()
    }
    
    @IBAction func stopMusic(_ sender: UIButton) {
        player.stop()
        player2.stop()
    }
    @objc func imageTapped(_ sender: UITapGestureRecognizer){
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.imageDrag(_:)))
        let photoView = UIImageView()
        photoView.frame = CGRect(x:200, y: 200, width: 200, height: 200)
        photoView.contentMode = .scaleAspectFill
        photoView.image = (sender.view as! UIImageView).image
        photoView.isUserInteractionEnabled = true
        photoView.addGestureRecognizer(panGesture)
        view.addSubview(photoView)
        
        let tagNo = sender.view?.tag
        print("ハロー", tagNo!)
    }
    
    @objc func imageDrag(_ sender: UIPanGestureRecognizer){
        sender.view!.center = sender.location(in: self.view)
        
    }
    
    @IBAction func dragging(_ sender: UIPanGestureRecognizer) {
        
    }
    
    func setupScrollContentView() {
        let contentView = scrollContentView!
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
                        ParfaitPart.getToppings()
                        ]
        allParts.forEach {
            let pageView = createPage(parts: $0)
            stack.addArrangedSubview(pageView)
            pageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pageView.widthAnchor.constraint(equalTo: scroll.widthAnchor),
                pageView.heightAnchor.constraint(equalTo: scroll.heightAnchor),
                ])
        }
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: CGFloat(allParts.count))
            ])
    }
    
    func createPage(parts : [ParfaitPart])->UIView{
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
        
        func createPartsImageView(_ image: UIImage) -> UIImageView {
            let img = UIImageView(image: image)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            img.contentMode = .scaleAspectFit
            img.isUserInteractionEnabled = true
            img.addGestureRecognizer(tapGesture)
            return img
        }
        
        let firstRowCount = parts.count / 2 + parts.count % 2
        for i in 0..<firstRowCount {
            stackH1.addArrangedSubview(createPartsImageView(parts[i].partImage))
        }
        for i in firstRowCount..<parts.count {
            stackH2.addArrangedSubview(createPartsImageView(parts[i].partImage))
        }
        
        return pageView
        
    }
}

