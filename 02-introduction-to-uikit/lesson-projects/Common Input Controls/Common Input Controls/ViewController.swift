//
//  ViewController.swift
//  Common Input Controls
//
//  Created by Brian Sipple on 3/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var inputTextLabel: UILabel!
    @IBOutlet weak var codeConnectedButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeConnectedButton.addTarget(self, action: #selector(codeConnectedButtonTapped), for: .touchUpInside)
    }

    
    @IBAction func codeConnectedButtonTapped(_ sender: UIButton) {
        print("⚡️")
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        print("Button was tapped! ◻️")
    }
    
    @IBAction func switchFlipped(_ sender: UISwitch) {
        print("Lights \(sender.isOn ? "On" : "Off")")
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        print("Sliding to \(sender.value)")
    }
    
    @IBAction func inputTextReturnKeyTapped(_ sender: UITextField) {
        inputTextLabel.text = "Input text entered: \(sender.text ?? "")"
    }
    
    @IBAction func inputTextChanged(_ sender: UITextField) {
        print("Input text changed: \(sender.text ?? "")")
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        print("view tapped at: \(sender.location(in: view))")
    }
    
}

