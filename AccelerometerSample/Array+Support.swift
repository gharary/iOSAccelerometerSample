//
//  Array+Support.swift
//  AccelerometerSample
//
//  Created by Mohammad Gharari on 7/2/21.
//

import Foundation

extension Sequence where Element: AdditiveArithmetic {
    /// Returns the total sum of all elements in the sequence
    func sum() -> Element { reduce(.zero, +) }
}
extension Collection where Element: BinaryFloatingPoint {
    /// Returns the average of all elements in the array
    func average() -> Element { isEmpty ? .zero : sum() / Element(count) }
    
    func stdev() -> Element {
        let length = self.count
        let avg = average()
        let sumOfSquaredAvgDiff = self.map({ pow(Double($0 - avg), 2.0)}).reduce(0, { $0 + $1 })
        
        return Self.Element(sqrt(sumOfSquaredAvgDiff / Double(length)))
    }
}
extension Array where Element == Double {
    func median() -> Double? {
        guard count > 0  else { return nil }

        let sortedArray = self.sorted()
        if count % 2 != 0 {
            return Double(sortedArray[count/2])
        } else {
            return Double(sortedArray[count/2] + sortedArray[count/2 - 1]) / 2.0
        }
    }
    
    func crossing() -> Double? {
        guard count > 0 else { return 0.0 }
        var countCrossing : Double = 0
        var preItem = self.first
        
        for elem in self {
            if preItem! > 0 && elem < 0 || preItem! < 0 && elem > 0 {
                countCrossing += 1
            }
            preItem = elem
        }
        return countCrossing
    }
    
}


