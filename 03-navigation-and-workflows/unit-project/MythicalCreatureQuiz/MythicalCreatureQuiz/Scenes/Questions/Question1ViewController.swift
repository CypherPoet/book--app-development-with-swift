//
//  Question1ViewController.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class Question1ViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    
    static let answerTags: [Int: Creature] = [
        1: .elf,
        2: .vampire,
        3: .mermaid,
        4: .wizard,
    ]
    
    lazy var question = Question(number: 1, text: "If presented, which food would you prefer the most?")
    
    weak var delegate: QuestionViewControllerDelegate? = nil
}


// MARK: - Lifecycle

extension Question1ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = question.text
    }
}


// MARK: - Event handling

extension Question1ViewController {
    
    @IBAction func answerSubmitted(_ button: UIButton) {
        guard let creatureAnswered = Question1ViewController.answerTags[button.tag] else {
            assertionFailure("Tag should correspond to a possible answer")
            return
        }
        
        handleAnswer(for: creatureAnswered)
    }
}


// MARK: - QuestionViewController

extension Question1ViewController: QuestionViewController {
    func handleAnswer(for creature: Creature) {
        question.answeredFor = creature
        
        delegate?.answerSubmitted(for: question)
    }
}
