//
//  AcceleroMngr.swift
//  AccelerometerSample
//
//  Created by Mohammad Gharari on 7/8/21.
//

import Foundation
import CoreMotion


class AcceleroManager {
    

    public static let sharedInstance = AcceleroManager()
    
    private init() {
    }
    
    var motion:CMMotionManager!
    var timer = Timer()
    
    // time for samples (20hz / 50 ms)
    var timeForSamples:Double = 0.05
    
    // time to refresh the UI
    var timeRefreshUI:Double = 1.0
    
    
    open func startAccelero() {
        
        timer = Timer.scheduledTimer(timeInterval: timeRefreshUI,target: self,selector: #selector(self.notifyUI), userInfo: nil, repeats: true)
        
        motion = CMMotionManager()
        
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = timeForSamples
            motion.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { (data, error) in
                if let data = data {
                    AcceleroModel.sharedInstance.insertData(x: data.acceleration.x,
                                                      y: data.acceleration.y,
                                                      z: data.acceleration.z)
                }
            })
        }
    }
    
    open func stop() {
        timer.invalidate()
        motion.stopAccelerometerUpdates()
    }
    
    @objc func notifyUI() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("AcceleroRefresh"), object: nil)
        }
    }
}
