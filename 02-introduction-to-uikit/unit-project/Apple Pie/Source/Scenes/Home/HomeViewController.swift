//
//  ViewController.swift
//  Apple Pie
//
//  Created by Brian Sipple on 3/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

// 📝 Ideally, this would be loaded in externally 🙂
let wordChoices = ["buccaneer", "swift", "glorious",
"incandescent", "bug", "program"]


class HomeViewController: UIViewController {
    @IBOutlet weak var winLossLabel: UILabel!
    @IBOutlet weak var answerLetterLabel: UILabel!
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    let maxGuesses = 7
    
    var currentGame: Game! {
        didSet { handleGameChange() }
    }
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(currentScore)"
        }
    }
    
    var totalWins = 0 {
        didSet { winLossLabel.text = winLossLabelText }
    }
    
    var totalLosses = 0 {
        didSet { winLossLabel.text = winLossLabelText }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentScore = 0
        totalWins = 0
        totalLosses = 0
        startNewRound()
    }
}


// MARK: - Computed Properties

extension HomeViewController {
    var currentTreeImage: UIImage {
        return UIImage(named: "Tree \(currentGame.mistakesRemaining)")!
    }
    
    var winLossLabelText: String {
        return "Wins: \(totalWins), Losses: \(totalLosses)"
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


// MARK: - Private Helper Methods

private extension HomeViewController {
    func startNewRound() {
        currentGame = Game(answerToGuess: wordChoices.randomElement()!, guessesRemaining: maxGuesses)
    }
    
    
    func handleGameChange() {
        treeImageView.image = currentTreeImage
        
        switch currentGame.state {
        default:
            break
        }
    }
    
}

