
import Foundation

public struct PeakHold {
    public struct Output {
        let vu: Float
        let peakHold: Float
        let counter: Int
    }
    
    public static func peakHoldCalculator1(data: UnsafeBufferPointer<Float>, peakHoldIn: Float, counterIn: Int, holdTime: Int, dropSpeed: Float) -> PeakHold.Output {

        let audio = Array(data)
        let squares = audio.map{pow($0,2)}
        let mean = squares.reduce(0,+) / Float(squares.count)
        let root = pow(mean,0.5)
        let vu=20*log10(root)
    
        var counter: Int = counterIn
        
        if vu > peakHoldIn{
            peakHold = vu
            counter = 0
        }
        else if counterIn > holdTime{
            peakHold = peakHold - dropSpeed
        }
        else{
            counter += 1
        }
        
        return PeakHold.Output(vu: vu, peakHold: peakHold, counter: counter)
    }
    
    public static func peakHoldCalculator2(data: UnsafeBufferPointer<Float>, peakHoldIn: Float, counterIn: Int, holdTime: Int, dropSpeed: Float) -> PeakHold.Output {

        let audio = Array(data)
        let squares = audio.map{pow($0,2)}
        let sx = audio.reduce(0,+) / 1024
        let sxx = squares.reduce(0,+) / 1024
        let sd = pow(sxx-pow(sx,0.5),0.5)
        let vu=20*log10(sd)
    
        var counter: Int = counterIn
        
        if vu > peakHoldIn{
            peakHold = vu
            counter = 0
        }
        else if counterIn > holdTime{
            peakHold = peakHold - dropSpeed
        }
        else{
            counter += 1
        }
        
        return PeakHold.Output(vu: vu, peakHold: peakHold, counter: counter)
    }
    
    public static func peakHoldCalculatorPointers1(data: UnsafeBufferPointer<Float>, peakHoldIn: Float, counterIn: Int, holdTime: Int, dropSpeed: Float) -> PeakHold.Output {

        let squares = data.map{pow($0,2)}
        let mean = squares.reduce(0,+) / Float(1024)
        let root = pow(mean,0.5)
        let vu=20*log10(root)
    
        var counter: Int = counterIn
        
        if vu > peakHoldIn{
            peakHold = vu
            counter = 0
        }
        else if counterIn > holdTime{
            peakHold = peakHold - dropSpeed
        }
        else{
            counter += 1
        }
        
        return PeakHold.Output(vu: vu, peakHold: peakHold, counter: counter)
    }
    
    public static func peakHoldCalculatorPointers2(data: UnsafeBufferPointer<Float>, peakHoldIn: Float, counterIn: Int, holdTime: Int, dropSpeed: Float, sampleCount: Int = 1024) -> PeakHold.Output {

        let sxx = data.reduce(0, {x, y in x + pow(y,2)})
        let mean = sxx / Float(sampleCount)
        let root = pow(mean,0.5)
        let vu = 20*log10(root)
    
        var counter: Int = counterIn
        
        if vu > peakHoldIn{
            peakHold = vu
            counter = 0
        }
        else if counterIn > holdTime{
            peakHold = peakHold - dropSpeed
        }
        else{
            counter += 1
        }
        
        return PeakHold.Output(vu: vu, peakHold: peakHold, counter: counter)
    }
}
