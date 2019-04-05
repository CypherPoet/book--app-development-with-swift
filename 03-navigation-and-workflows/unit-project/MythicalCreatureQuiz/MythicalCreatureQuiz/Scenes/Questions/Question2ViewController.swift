//
//  Question2ViewController.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class Question2ViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerSwitch: [UISwitch]!
    @IBOutlet weak var submitButton: UIButton!
    
    enum SubmissionState {
        case submitEnabled
        case submitDisabled
    }
    
    var currentSubmissionState: SubmissionState = .submitDisabled {
        didSet { submissionStateChanged() }
    }
    
    lazy var question: Question = Question(text: "Members of your species have lived to...")
    weak var delegate: QuestionViewControllerDelegate? = nil
}


// MARK: - Computed Properties

extension Question2ViewController {
    var canSubmitAnswer: Bool {
        return answerSwitch.first { $0.isOn == true } != nil
    }
}


// MARK: - Lifecycle

extension Question2ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = question.text
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
    }
}


// MARK: - Event handling

extension Question2ViewController {
    @IBAction func answerSwitchFlipped(_ sender: UISwitch) {
        currentSubmissionState = canSubmitAnswer ? .submitEnabled : .submitDisabled
    }
    
    
    @IBAction func submitButtonTapped(_ button: UIButton) {
        // TODO: Handle logic
        
        // (All: Assume wizard)
        //
        // -10 years (if checked: wizard)
        //
        // Lived? (only: vampire)
        //
        // 300 years (only: mermaid)
        //
        // 1000+ years (only: elf)
        //
        // Lived? + 300 years: vampire
        //
        // 300 + 1000:
        //     - is -10 checked: wizard
        //          - else: elf
        //
        // Any other two: wizard
        
    }

    
}


// MARK: - Private Helper Methods

extension Question2ViewController {
    func submissionStateChanged() {
        switch currentSubmissionState {
        case .submitDisabled:
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.submitButton.alpha = 0.5
            })
        case .submitEnabled:
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.submitButton.alpha = 1.0
            })
        }
    }
}



// MARK: - QuestionViewController

extension Question2ViewController: QuestionViewController {
    func handleAnswer(for creature: Creature) {
        question.answeredFor = creature
        
        delegate?.answerSubmitted(for: question)
    }
}
