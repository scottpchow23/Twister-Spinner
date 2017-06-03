//
//  ViewController.swift
//  Twister Spinner
//
//  Created by Scott P. Chow on 6/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let bodyParts : [String] = ["left hand", "right hand", "left foot", "right foot"]
    let colors : [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow];
    
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
        let spin = (bodyParts[Int(arc4random()%4)], colors[Int(arc4random()%4)])
        print(spin)
        self.view.backgroundColor = spin.1
        self.bodyPartLabel.text = spin.0
    }


}

