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
    
    var revealedAnswer: String {
        return currentGame.answerToGuess.reduce("", { (accumulated, currentCharacter) -> String in
            if currentGame.remainingLettersToGuess.contains(currentCharacter) {
                return accumulated + "_"
            }
            return accumulated + String(currentCharacter)
        })
    }
    
    var formattedAnswerText: String {
        return revealedAnswer
            .map{ String($0) }
            .joined(separator: " ")
    }
}


// MARK: - Event handling

extension HomeViewController {
    @IBAction func letterButtonPressed(_ button: UIButton) {
        guard let letter = button.title(for: .normal) else {
            fatalError("Failed to read letter from button")
        }
        
        currentGame.letterGuessed(letter.lowercased())
        
        button.isEnabled = false
    }
}


// MARK: - Private Helper Methods

private extension HomeViewController {
    func startNewRound() {
        letterButtons.forEach { $0.isEnabled = true }
        currentGame = Game(answerToGuess: wordChoices.randomElement()!, guessesRemaining: maxGuesses)
    }
    
    
    func handleGameChange() {
        treeImageView.image = currentTreeImage
        answerLetterLabel.text = formattedAnswerText
        
        switch currentGame.state {
        case .lost:
            handleLoss()
        case .won:
            handleWin()
        case .playing:
            break
        }
    }
    
    
    func handleLoss() {
        let alertController = UIAlertController(
            title: "Round Lost",
            message: "Sorry, the correct word was \"\(currentGame.answerToGuess)\". Press OK to start a new round",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                self.currentScore = max(0, self.currentScore - 1)
                self.totalLosses += 1
                self.startNewRound()
            }
        )
        
        present(alertController, animated: true)
    }
    

    func handleWin() {
        let alertController = UIAlertController(
            title: "Well Done! 👏",
            message: "You won the round. Press OK to continue to the next level",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let self = self else { return }

                self.currentScore += 3
                self.totalWins += 1
                self.startNewRound()
            }
        )
        
        present(alertController, animated: true)
    }
}

