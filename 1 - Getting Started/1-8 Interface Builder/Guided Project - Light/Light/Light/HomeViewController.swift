//
//  ViewController.swift
//  Light
//
//  Created by Brian Sipple on 2/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

enum LightState {
    case on
    case off
}

let buttonTitles = [
    LightState.on: "🌑",
    LightState.off: "☀️",
]


class HomeViewController: UIViewController {
    @IBOutlet weak var lightButton: UIButton!
    
    var currentLightState = LightState.on {
        didSet {
            lightStateChanged()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lightStateChanged()
    }
    
    
    func lightStateChanged() {
        switch currentLightState {
        case .on:
            view.backgroundColor = UIColor.white
            lightButton.setTitle(buttonTitles[.on], for: .normal)
        case .off:
            view.backgroundColor = UIColor.black
            lightButton.setTitle(buttonTitles[.off], for: .normal)
        }
    }


    @IBAction func lightButtonPressed(_ sender: Any) {
        currentLightState = currentLightState == .on ? .off : .on
    }
}

