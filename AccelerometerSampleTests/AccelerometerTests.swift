//
//  SentianceAccelerometerTests.swift
//  AccelerometerSampleTests
//
//  Created by Mohammad Gharari on 7/2/21.
//

import XCTest
import Accelerate
@testable import Sentiance
class AccelerometerTests: XCTestCase {

    var model:AcceleroModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        model = AcceleroModel.sharedInstance
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        model = nil
        try super.tearDownWithError()
    }

    func testMedianxAxis() {
        // given
        let xArray = [-1.0,-5.0,5.0,6.0,10.0,2.0,4.0,7.0]

        
        // when
        let median = xArray.median()
        
        XCTAssertEqual(median, 4.5, "Median calculated wrongly!")
    }

    func testCalculateMax() {
        // given
        let zArray = [-10,-12,22,3,7,17,0,5,2]
        
        // when
        let max = zArray.max()
        
        XCTAssertEqual(max, 22, "Max calculated wrongly!")
    }
    
    func testZeroCrossing() {
        // given
        let xArray = [-1.0,0.0,1.0,-1.0,2.0,10.0,-2.0,0.0]
        
        // when
        let zeroCrossCount = xArray.crossing()
        
        // then
        XCTAssertEqual(zeroCrossCount, 3, "Zero crossing calculated wrongly")
    }
    
    func testStandardDeviation() {
        //given
        let yArray = [-1.0,-5.0,1.0,-1.0,22,3,7]
        // when
        let stdev = yArray.stdev()
        
        XCTAssertEqual(stdev, 8.223907408356716, "StDev calculated wrongly!")
    }
    
    func testMean() {
        //given
        let xArray = [-1.0,0.0,1.0,-5.0,1.0,-1.0,-5.0,5.0,6.0,10.0]
        
        //when
        let mean = vDSP.mean(xArray)
        
        XCTAssertEqual(mean, xArray.average(), "Calculated wrongly")
    }
}
