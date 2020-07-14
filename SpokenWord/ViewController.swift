/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The root view controller that provides a button to start and stop recording, and which displays the speech recognition results.
*/

import UIKit
import Speech

var peakHold = Float(-100)
var r = 0
let n = 15
let dropSpeed = Float(1.5)

public class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    // MARK: Properties
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var display: UIView!
    
    @IBOutlet var recordButton: UIButton!
    
    var background: UIView!
    
    var bar: UIView!
    
    var line: UIView!
    
    // MARK: View Controller Lifecycle
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        background = UIView(frame: CGRect(x: 150, y: 300, width: 100, height: 400))
        background.backgroundColor=UIColor.lightGray
        self.view.addSubview(background)
        
        bar = UIView(frame: CGRect(x: 150, y: 350, width: 100, height: 0))
        bar.backgroundColor=UIColor.green
        self.view.addSubview(bar)
        
        line = UIView(frame: CGRect(x: 150, y: 698, width: 100, height: 2))
        line.backgroundColor=UIColor.green
        self.view.addSubview(line)
    }
    
    private func startRecording() throws {
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setPreferredSampleRate(48000)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        // Configure the microphone input.
        let bus = 0
        let inputFormat = inputNode.outputFormat(forBus: bus )
        
        inputNode.removeTap(onBus: bus)

        // Sample rate here frigged to give us 1024 samples a second, play around with this...!
        guard let outputFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 10240, channels: 1, interleaved: true), let converter = AVAudioConverter(from: inputFormat, to: outputFormat) else{
            return
        }

        inputNode.installTap(onBus: bus, bufferSize: 1024, format: inputFormat) { (buffer, time) -> Void in
            var newBufferAvailable = true

            let inputCallback: AVAudioConverterInputBlock = { inNumPackets, outStatus in
                if newBufferAvailable {
                    outStatus.pointee = .haveData
                    newBufferAvailable = false
                    return buffer
                } else {
                    outStatus.pointee = .noDataNow
                    return nil
                }
            }

            if let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(outputFormat.sampleRate) * buffer.frameLength / AVAudioFrameCount(buffer.format.sampleRate)){
                var error: NSError?
                let status = converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputCallback)
                assert(status != .error)

                if let buffer = convertedBuffer.floatChannelData?.pointee {
                    let bufferPointer = UnsafeBufferPointer<Float>(start: buffer, count: Int(convertedBuffer.frameLength))

                    let floats = Array(bufferPointer)
                    
                    
                    let squares = floats.map{pow($0,2)}
                    let mean = squares.reduce(0,+) / Float(squares.count)
                    let root = pow(mean,0.5)
                    let vu=20*log10(root)
                    if vu > peakHold{
                        peakHold = vu
                        r = 0
                    }
                    else if r > n{
                        peakHold = peakHold - dropSpeed
                    }
                    else{
                        r+=1
                    }
                    
                    let normalisedVu = pow(10,vu/80)
                    let normalisedPeakHold = pow(10,peakHold/80)
                    
                    DispatchQueue.main.async {
                        self.bar.frame =
                            CGRect(x: 150, y: 700 - 400*CGFloat(normalisedVu), width: 100, height: 400*CGFloat(normalisedVu))
                        
                        self.line.frame =
                            CGRect(x: 150, y: 700 - 400*CGFloat(normalisedPeakHold), width: 100, height: 2)
                    }
                }
            }
        }

        audioEngine.prepare()
        try audioEngine.start()
    }
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recordButton.setTitle("Start recording", for: .disabled)
        } else {
            do {
                try startRecording()
                recordButton.setTitle("Stop Recording", for: [])
            } catch {
                recordButton.setTitle("Recording Not Available", for: [])
            }
        }
    }
}
