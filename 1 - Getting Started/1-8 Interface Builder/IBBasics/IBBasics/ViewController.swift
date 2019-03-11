//
//  ViewController.swift
//  IBBasics
//
//  Created by Brian Sipple on 2/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

enum LabelState {
    case reppingIB
    case reppingSwift
}

class ViewController: UIViewController {
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    
    var currentLabelState = LabelState.reppingIB {
        didSet {
            labelStateChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        labelStateChanged()
    }
    
    
    func labelStateChanged() {
        switch currentLabelState {
        case .reppingIB:
            mainLabel.text = "Interface Builder is 🔥."
        case .reppingSwift:
            mainLabel.text = "So is coding UI in Swift ✨."
        }
    }
    

    @IBAction func mainButtonPressed(_ sender: Any) {
        currentLabelState = currentLabelState == .reppingIB ? .reppingSwift : .reppingIB
    }
    
}

