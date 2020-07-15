//
//  Peak_HoldTests.swift
//  Peak HoldTests
//
//  Created by Max Booth on 14/07/2020.
//  Copyright © 2020 Max Booth. All rights reserved.
//

import XCTest
@testable import Peak_Hold

let holdTime = 15
var counter = 0
let dropSpeed: Float = 1.5
var peakHold: Float = -100
var floats: [Float] = Array(repeating: 0, count: 1000)

class Peak_HoldTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        
        var testArrays: [[Float]] = []
        for _ in 0...99 {
            var testArray: [Float] = []
            for _ in 0...999 {
                testArray.append(Float.random(in: -1..<1))
            }
            testArrays.append(testArray)
        }
        
        self.measure {
            for i in 0...99{
                let output = PeakHold.peakHoldCalculator1(audio: testArrays[i], peakHoldIn: peakHold, counterIn: counter, holdTime: holdTime, dropSpeed: dropSpeed)
                peakHold = output.peakHold
                counter = output.counter
            }
        }
    }
}
