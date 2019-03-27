//
//  ViewController.swift
//  TrafficSegues
//
//  Created by Brian Sipple on 3/25/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class RedViewController: UIViewController {
    @IBOutlet weak var nextTitleText: UITextField!
    
    
    enum NavLockState {
        case enabled, disabled
    }
    
    var currentNavLockState: NavLockState = .enabled
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}


// MARK: - Event handling

extension RedViewController {
    @IBAction func navLockStateToggled(_ sender: UISwitch) {
        currentNavLockState = sender.isOn ? .disabled : .enabled
    }
    
    @IBAction func showYellowTapped(_ sender: UIButton) {
        if currentNavLockState == .enabled {
            performSegue(withIdentifier: StoryboardID.Segue.showYellow, sender: sender)
        }
    }
    
    @IBAction func showGreenTapped(_ sender: UIButton) {
        if currentNavLockState == .enabled {
            performSegue(withIdentifier: StoryboardID.Segue.showGreen, sender: sender)
        }
    }
}



// MARK: - Navigation

extension RedViewController {
    @IBAction func unwindToRed(for unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.navigationItem.title = nextTitleText.text ?? ""
    }
}

