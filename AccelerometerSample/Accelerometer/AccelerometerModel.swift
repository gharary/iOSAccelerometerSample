//
//  AccelerometerModel.swift
//  AccelerometerSample
//
//  Created by Mohammad Gharari on 7/1/21.
//

import Foundation
import CoreMotion
import Accelerate
open class AcceleroModel {
    
    public static let sharedInstance = AcceleroModel()
    
    private init() { }
    
    let motion = CMMotionManager()
    let queue = OperationQueue()
    
     var xArrays :[Double] = []
     var yArrays :[Double] = []
     var zArrays :[Double] = []

    
    open func insertData(x:Double,y:Double,z:Double) {
        xArrays.append(x)
        yArrays.append(y)
        zArrays.append(z)
    }
    
    open func calcStats(array:[Double]) -> [Double] {
        /// calculate max
        let max = array.count > 0 ? array.max()! : 0.0
        
        // calculate median
        let median = array.count > 0 ? array.median()! : 0.0
        
        // calculate mean
        let mean = array.count > 0 ? array.average() : 0.0
        
        // calculate min
        let min = array.count > 0 ? array.min()! : 0.0
        
        // calculate standard deviation
        let stdev = array.count > 0 ? array.stdev() : 0.0
        
        // calculate crossing
        let crossings = array.count > 0 ? array.crossing()! : 0.0
        
        
        return [max,median,mean,stdev,min,Double(array.count),crossings]
        
    }
    open func clearData() {
        xArrays = []
        yArrays = []
        zArrays = []
    }
    
}
