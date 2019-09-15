//
//  ViewController.swift
//  parfait_scroll
//
//  Created by Oka Ayumi on 2019/08/10.
//  Copyright © 2019 Oka Ayumi. All rights reserved.
//

import UIKit
class ViewController: UIViewController{
    
    
    @IBAction func dragging(_ sender: UIPanGestureRecognizer) {
        
    }
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var scroll2: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollContentView = createContentView()
        scroll.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollContentView.heightAnchor.constraint(equalTo: scroll.heightAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 5),
            scrollContentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            ])
        scroll.contentSize = scroll.frame.size
        scroll.isPagingEnabled = true
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
    
    func createContentView() -> UIView {
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return contentView
        
        let stack = UIStackView()
        
        contentView.addSubview(stack)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        
        let allParts = [ParfaitPart.getToppings(),
                        ParfaitPart.getTopIces(),
                        ParfaitPart.getFruits(),
                        ParfaitPart.getBottomIces(),
                        ParfaitPart.getSyrups()]
        for i in 0...4{
            
            let pageView = createPage(parfaitParts: allParts[i])
            stack.addArrangedSubview(pageView)
            //pageView.translatesAutoresizingMaskIntoConstraints = false
            //pageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
            //pageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
            
            
            
        }
        return contentView
        
    }
    func createPage(parfaitParts : [ParfaitPart])->UIView{
        let pageView = UIView()
        
        
        
        
        
        
        //ここからスタック追加コード
        let stackV:UIStackView = UIStackView()
        pageView.addSubview(stackV)
        stackV.backgroundColor = UIColor.cyan
        stackV.axis = .vertical
        stackV.translatesAutoresizingMaskIntoConstraints = false
        stackV.widthAnchor.constraint(equalTo: pageView.widthAnchor).isActive = true
        stackV.heightAnchor.constraint(equalTo: pageView.heightAnchor).isActive = true
        stackV.distribution = .fillEqually
        
        let stackH1:UIStackView = UIStackView()
        let stackH2:UIStackView = UIStackView()
        stackV.addArrangedSubview(stackH1)
        stackV.addArrangedSubview(stackH2)
        
        stackH1.backgroundColor = UIColor.cyan
        stackH1.axis = .horizontal
        stackH1.frame = CGRect(x: 0, y: 0, width: stackV.frame.width, height: stackV.frame.height / 2)
        stackH1.distribution = .fillEqually
        stackH2.backgroundColor = UIColor.cyan
        stackH2.axis = .horizontal
        stackH2.frame = CGRect(x: 0, y: 0, width: stackV.frame.width, height: stackV.frame.height / 2)
        stackH2.distribution = .fillEqually
        
        
        
        for i in 0...2 {
            let img = UIImageView(image: parfaitParts[i].partImage)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            img.isUserInteractionEnabled = true
            img.addGestureRecognizer(tapGesture)
            stackH1.addArrangedSubview(img)
        }
        
        for i in 3...4 {
            let img = UIImageView(image: parfaitParts[i].partImage)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            img.isUserInteractionEnabled = true
            img.addGestureRecognizer(tapGesture)
            stackH2.addArrangedSubview(img)
        }
        
        
        
        
        
        
        
        
        
        //ここまで
        
        
        
        return pageView
        
    }
    
    
    
}

