//
//  ViewController.swift
//  VolumeViewManager
//
//  Created by Bo Wang on 2019/1/25.
//  Copyright © 2019 Bo Wang. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {

    var player: AVPlayer!
    var playerViewLayer: AVPlayerLayer!
    @IBOutlet weak var changeVolumeButton: UIButton!
    
    let volumeView = CustomerVolumeView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
        
        setupCustomVolumeView()
        
        player.play()
    }
    
    func setupUI() {
        player = AVPlayer.init(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
        playerViewLayer = AVPlayerLayer.init(player: player)
        playerViewLayer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(180 * Double.pi / 180.0)))
        playerViewLayer.frame = view.frame
        view.layer.addSublayer(playerViewLayer)
        
        changeVolumeButton.layer.borderColor = UIColor.white.cgColor
        changeVolumeButton.layer.borderWidth = 1
        changeVolumeButton.layer.cornerRadius = 10
        
        view.bringSubviewToFront(changeVolumeButton)
    }
    
    func setupCustomVolumeView() {
        VolumeViewManager.shared.add(volumeView)
        let frame = CGRect.init(x: view.frame.width - volumeView.frame.width - 20,
                                y: view.center.y - volumeView.frame.height / 2,
                                width: volumeView.frame.width,
                                height: volumeView.frame.height)
        volumeView.frame = frame
        view.addSubview(volumeView)
        
    }
    
    @IBAction func changeVolumeView(_ sender: UIButton) {
        VolumeViewManager.shared.showsCustomVolumeView = !VolumeViewManager.shared.showsCustomVolumeView
        
        if VolumeViewManager.shared.showsCustomVolumeView {
            sender.setTitle("System", for: .normal)
        } else {
            sender.setTitle("Custom", for: .normal)
        }
    }


}

