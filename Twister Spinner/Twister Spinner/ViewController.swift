//
//  ViewController.swift
//  Twister Spinner
//
//  Created by Scott P. Chow on 6/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let bodyParts : [String] = ["left hand", "right hand", "left foot", "right foot"]
    let colors : [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    let colorNames : [String] = ["red", "blue", "green", "yellow"]
    let bodyImages : [UIImage] = [#imageLiteral(resourceName: "icons8-Left Hand"), #imageLiteral(resourceName: "icons8-Right Hand"), #imageLiteral(resourceName: "icons8-Left Footprint"), #imageLiteral(resourceName: "icons8-Right Footprint")]
    let synth = AVSpeechSynthesizer()
    
    @IBOutlet weak var bodyPartImageView: UIImageView!
    @IBOutlet weak var bodyPartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spin)))
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


}

