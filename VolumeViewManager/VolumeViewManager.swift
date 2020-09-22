//
//  VolumeViewManager.swift
//  VolumeViewManager
//
//  Created by Bo Wang on 2019/1/25.
//  Copyright © 2019 Bo Wang. All rights reserved.
//

import Foundation
import MediaPlayer

/// 自定义 Volume 视图
@objc public protocol CustomVolumeViewDelegate {
    func volumeChanged(_ volume: Float)
}

//@objcMembers
class VolumeViewManager: NSObject {
    
    /// VolumeViewManager 采用单例模式
    static public let shared = VolumeViewManager.init()
    public var observers: NSHashTable<CustomVolumeViewDelegate> = NSHashTable.weakObjects()
    
    private let mpVolumeView: MPVolumeView!
    @objc private var mpVolumeSlider: UISlider!
    private var customVolumeViewAvailable = false
    private var observation: NSKeyValueObservation!
    
    /// 屏蔽初始化方法
    private override init() {
        mpVolumeView = MPVolumeView.init(frame: CGRect.init(x: -100, y: -100, width: 1, height: 1))
        
        super.init()
        
        mpVolumeView.subviews.forEach { (view) in
            if view.isKind(of: UISlider.self) {
                mpVolumeSlider = (view as! UISlider)
            }
        }
        
    }
    
    private func changeCustomVolumeViewAvailable(_ enable: Bool) {
        customVolumeViewAvailable = enable
        if enable {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
                if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                    rootVC.view.addSubview(self.mpVolumeView)
                    self.setupObserver()
                    timer.invalidate()
                }
            }
        } else {
            mpVolumeView.removeFromSuperview()
            observation.invalidate()
            removeAllObservers()
        }
    }
    
    private func setupObserver() {
        observation = AVAudioSession.sharedInstance().observe(\.outputVolume, options: [.new, .old]) { (slider, change) in
            self.observers.allObjects.forEach({ (delegate) in
                delegate.volumeChanged(change.newValue ?? 0)
            })
        }
    }
    
}

extension VolumeViewManager {
    public func add(_ observer: CustomVolumeViewDelegate) {
        observers.add(observer)
    }
    
    public func remove(_ observer: CustomVolumeViewDelegate) {
        observers.remove(observer)
    }
    
    private func removeAllObservers() {
        observers.removeAllObjects()
    }
}

extension VolumeViewManager {
    public var showsCustomVolumeView: Bool {
        get {
            return customVolumeViewAvailable
        }
        
        set {
            changeCustomVolumeViewAvailable(newValue)
        }
    }
}




