//
//  ViewController.swift
//  Apple Pie
//
//  Created by Brian Sipple on 3/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var answerSpacesLabel: UILabel!
    @IBOutlet weak var answerLetterLabel: UILabel!
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    var answerWord = ""
    
    var currentAnswer = "" {
        didSet {
            
        }
    }
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(currentScore)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}


// MARK: - Event handling

extension HomeViewController {
    @IBAction func letterButtonPressed(_ button: UIButton) {
        guard let letter = button.titleLabel?.text else {
            fatalError("Failed to read letter from button")
        }
        
        button.isEnabled = false
    }
}

