//
//  ResultsViewController.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/3/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var creatureSymbolLabel: UILabel!
    @IBOutlet weak var resultDescriptionLabel: UILabel!
    
    
    var creatureAnswer: Creature!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}


// MARK: - Computed Properties

extension ResultsViewController {
    
    var resultDescription: String {
        guard let creature = creatureAnswer else {
            fatalError("ResultsViewController has no answer")
        }
        
        switch creature {
        case .elf:
            return "You turned out to be an Elf!"
        case .mermaid:
            return "You turned out to be a Mermaid!"
        case .vampire:
            return "You turned out to be a Vampire!"
        case .wizard:
            return "You're a Wizard!"
        }
    }
}



// MARK: - Private Helper Methods

extension ResultsViewController {
    
    func setupUI() {
        navigationItem.hidesBackButton = true
        
        creatureSymbolLabel.text = creatureAnswer.rawValue
        resultDescriptionLabel.text = resultDescription
    }
}
