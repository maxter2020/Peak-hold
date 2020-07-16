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
    
    var testData: [UnsafeBufferPointer<Float>] = []
    
    override func setUp() {
        for _ in 0...9999 {
            let testPointers = UnsafeMutablePointer<Float>.allocate(capacity: 1024)
            let testBuffer: UnsafeBufferPointer<Float>
            for i in 0...1023 {
                testPointers[i] = Float.random(in: -1..<1)
            }
            testBuffer = UnsafeBufferPointer(start: testPointers, count: 1024)
            testData.append(testBuffer)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPeakHoldCalculatorSlow() {
        self.measure {
            for i in 0...9999{
                let output = PeakHold.peakHoldCalculatorSlow(data: testData[i], peakHoldIn: peakHold, counterIn: counter, holdTime: holdTime, dropSpeed: dropSpeed)
                peakHold = output.peakHold
                counter = output.counter
            }
        }
    }
    
    func testPeakHoldCalculatorMedium() {
        self.measure {
            for i in 0...9999{
                let output = PeakHold.peakHoldCalculatorMedium(data: testData[i], peakHoldIn: peakHold, counterIn: counter, holdTime: holdTime, dropSpeed: dropSpeed)
                peakHold = output.peakHold
                counter = output.counter
            }
        }
    }
    
    func testPeakHoldCalculatorFastest() {
        self.measure {
            for i in 0...9999{
                let output = PeakHold.peakHoldCalculatorFastest(data: testData[i], peakHoldIn: peakHold, counterIn: counter, holdTime: holdTime, dropSpeed: dropSpeed)
                peakHold = output.peakHold
                counter = output.counter
            }
        }
    }
    
    func testPeakHoldCalculatorForLoop() {
        self.measure {
            for i in 0...9999{
                let output = PeakHold.peakHoldCalculatorForLoop(data: testData[i], peakHoldIn: peakHold, counterIn: counter, holdTime: holdTime, dropSpeed: dropSpeed)
                peakHold = output.peakHold
                counter = output.counter
            }
        }
    }
    
    func testPeakHoldCalculatorNotPow() {
        self.measure {
            for i in 0...9999{
                let output = PeakHold.peakHoldCalculatorNotPow(data: testData[i], peakHoldIn: peakHold, counterIn: counter, holdTime: holdTime, dropSpeed: dropSpeed)
                peakHold = output.peakHold
                counter = output.counter
            }
        }
    }
}
