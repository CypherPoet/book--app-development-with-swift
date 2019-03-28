//
//  ViewController.swift
//  Login
//
//  Created by Brian Sipple on 3/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var username: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let username = username else { return }
        
        welcomeLabel.text = "Welcome, \(username)!"
    }
}

