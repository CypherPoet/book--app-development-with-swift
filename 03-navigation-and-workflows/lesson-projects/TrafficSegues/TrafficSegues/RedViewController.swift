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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

