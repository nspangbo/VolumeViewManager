//
//  CustomerVolumeView.swift
//  VolumeViewManager
//
//  Created by Bo Wang on 2019/1/25.
//  Copyright © 2019 Bo Wang. All rights reserved.
//

import UIKit
import AVFoundation

class CustomerVolumeView: UIView {
    
    var grayVolumeBar: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {

        grayVolumeBar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: Int((1 - AVAudioSession.sharedInstance().outputVolume) * 140)))
        grayVolumeBar.backgroundColor = UIColor.gray
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 140))
        
        self.backgroundColor = UIColor.white
        addSubview(grayVolumeBar)
    }
    
}

extension CustomerVolumeView: CustomVolumeViewDelegate {
    func volumeChanged(_ volume: Float) {
        print("volumeChanged: \(volume)")
        
        UIView.animate(withDuration: 0.1) {
            let frame = CGRect.init(x: 0, y: 0, width: 10, height: Int((1-volume) * 140.0))
            self.grayVolumeBar.frame = frame
        }
    }
}
