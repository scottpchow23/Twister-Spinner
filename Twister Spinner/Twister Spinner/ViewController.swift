//
//  ViewController.swift
//  Twister Spinner
//
//  Created by Scott P. Chow on 6/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
//  MARK : Speech Recognition Variables
    private var listening = false
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
//  MARK : Spinner Constants
    let bodyParts : [String] = ["left hand", "right hand", "left foot", "right foot"]
    let colors : [UIColor] = [UIColor.init(red: 0xFF / 255, green: 0x00 / 255, blue: 0x00 / 255, alpha: 1),
                              UIColor.init(red: 0x00 / 255, green: 0xEB / 255, blue: 0xFF / 255, alpha: 1),
                              UIColor.init(red: 0x82 / 255, green: 0xFF / 255, blue: 0x00 / 255, alpha: 1),
                              UIColor.init(red: 0xFF / 255, green: 0xFF / 255, blue: 0x00 / 255, alpha: 1)]
    let colorNames : [String] = ["red", "blue", "green", "yellow"]
    let bodyImages : [UIImage] = [#imageLiteral(resourceName: "icons8-Left Hand"), #imageLiteral(resourceName: "icons8-Right Hand"), #imageLiteral(resourceName: "icons8-Left Footprint"), #imageLiteral(resourceName: "icons8-Right Footprint")]
    let synth = AVSpeechSynthesizer()
    
    @IBOutlet weak var bodyPartImageView: UIImageView!
    @IBOutlet weak var bodyPartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spin)))
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        speechRecognizer?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func spin() {
        let bodySpin = Int(arc4random()%4)
        let colorSpin = Int(arc4random()%4)
        let spin = (bodyParts[bodySpin], colors[colorSpin], bodyImages[bodySpin], colorNames[colorSpin])
        print(spin)
        self.bodyPartImageView.image = spin.2
        
        self.view.backgroundColor = spin.1
        
        self.bodyPartLabel.text = spin.0
        let utterance = AVSpeechUtterance(string: "\(spin.0) to \(spin.3) ")
        synth.speak(utterance)
    }

    private func askMicPermission(completion: @escaping (Bool, String) -> ()) {
        SFSpeechRecognizer.requestAuthorization { (status) in
            let message: String
            var granted = false
            
            switch status {
            case .authorized:
                message = "Listening..."
                granted = true
                break
            case .denied:
                message = "Access to speech recognition is denied by the user."
                break
            case .restricted:
                message = "Speech recognition is restricted."
                break
            case .notDetermined:
                message = "Speech recognition has not been authorized, yet."
                break
            }
            completion(granted,message)
        }
    }
    @IBAction func toggleMicrophoneButtonTouchUpInside(_ sender: Any) {
        askMicPermission { (granted, message) in
            
        }
    }
    
    private func startListening() {
        
//      Check if recognition task is running, canceling it if there is one
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
//      Try to activate the audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch let error {
            print(error.localizedDescription)
        }
        
//      Create a recognition request that takes an audio buffer as input
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let inputNode = audioEngine.inputNode else {
            fatalError("No audio node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Couldn't create SFSpeechAudioBufferRequestObject")
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if result != nil {
                let bestTranscription = result?.bestTranscription.formattedString
                if bestTranscription == "Next" {
                    
                }
                isFinal = result!.isFinal
            }
            
            
            if error != nil || isFinal {
                if let error = error {
                    print(error.localizedDescription)
                }
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                
            }
            
        })
    }
}



