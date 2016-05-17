//
//  ViewController.swift
//  my-little-monster
//
//  Created by Ryan Walsh on 5/17/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImage: MonsterImage!
    @IBOutlet weak var heartImage: DragImage!
    @IBOutlet weak var foodImage: DragImage!
    
    @IBOutlet weak var skullImageOne: UIImageView!
    @IBOutlet weak var skullImageTwo: UIImageView!
    @IBOutlet weak var skullImageThree: UIImageView!
    
    let dimAlpha: CGFloat = 0.2
    let opaque: CGFloat = 1.0
    
    let maxPenalties = 3
    var penalties = 0
    var timer: NSTimer!
    
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: #selector(itemDroppedOnCharacter), name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
        } catch let err as NSError {
            print( err.debugDescription)
        }
        
        startTimer()
    }

    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        heartImage.alpha = dimAlpha
        heartImage.userInteractionEnabled = false
        foodImage.alpha = dimAlpha
        foodImage.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        if !monsterHappy {
            sfxSkull.play()
            penalties += 1
            switch(penalties) {
                case 1:
                    skullImageOne.alpha = opaque
                    skullImageTwo.alpha = dimAlpha
                case 2:
                    skullImageOne.alpha = opaque
                    skullImageTwo.alpha = opaque
                    skullImageThree.alpha = dimAlpha
                case 3:
                    skullImageOne.alpha = opaque
                    skullImageTwo.alpha = opaque
                    skullImageThree.alpha = opaque
                default:
                    skullImageOne.alpha = dimAlpha
                    skullImageTwo.alpha = dimAlpha
                    skullImageThree.alpha = dimAlpha
            }
            
            if penalties >= maxPenalties {
                gameOver()
            }
        }
        
        currentItem = arc4random_uniform(2)
        
        if currentItem == 0 {
            foodImage.alpha = dimAlpha
            foodImage.userInteractionEnabled = false
            
            heartImage.alpha = opaque
            heartImage.userInteractionEnabled = true
        } else {
            foodImage.alpha = opaque
            foodImage.userInteractionEnabled = true
            
            heartImage.alpha = dimAlpha
            heartImage.userInteractionEnabled = false
        }
        
        monsterHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        sfxDeath.play()
        monsterImage.playDeathAnimation()
    }

}

