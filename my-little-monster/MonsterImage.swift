//
//  MonsterImage.swift
//  my-little-monster
//
//  Created by Ryan Walsh on 5/17/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import Foundation
import UIKit

class MonsterImage: UIImageView {
    override init( frame: CGRect ) {
        super.init( frame: frame );
    }
    
    required init?(coder aDecoder: NSCoder ) {
        super.init( coder: aDecoder )
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        
        var imageArray = [UIImage]()
        
        for i in 1...4 {
            imageArray.append( UIImage( named: "idle \(i).png")!)
        }
        
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        
        self.image = UIImage(named: "dead5.png")
        
        self.animationImages = nil
        
        var imageArray = [UIImage]()
        
        for i in 1...5 {
            imageArray.append( UIImage( named: "dead\(i).png")!)
        }
        
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
}