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
    @IBOutlet var answerSwitches: [UISwitch]!
    @IBOutlet weak var submitButton: UIButton!
    
    enum SubmissionState {
        case submitEnabled
        case submitDisabled
    }
    
    enum AnswerTag {
        static let negativeTenYears = 1
        static let lived = 2
        static let threeHundredYears = 3
        static let oneThousandPlusYears = 4
    }
    
    var currentSubmissionState: SubmissionState = .submitDisabled {
        didSet { submissionStateChanged() }
    }
    
    lazy var question: Question = Question(number: 2, text: "Members of your species have lived to...")
    
    weak var delegate: QuestionViewControllerDelegate? = nil
}


// MARK: - Computed Properties

extension Question2ViewController {
    var canSubmitAnswer: Bool {
        return answerSwitches.first { $0.isOn == true } != nil
    }
    
    var tagsActivated: [Int] {
        return answerSwitches
            .filter { $0.isOn }
            .map { $0.tag }
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
        guard tagsActivated.count > 0 else {
            preconditionFailure("Submit should not be enabled until a switch is activated.")
        }
        
        guard tagsActivated.count <= 4 else {
            preconditionFailure("Too many switch tags are being recorded")
        }
        
        if tagsActivated.count == 4 {
            // All: Assume wizard
            handleAnswer(for: .wizard)
        } else if tagsActivated.count == 1 {
            switch tagsActivated[0] {
            case AnswerTag.negativeTenYears:
                // -10 years only: wizard
                handleAnswer(for: .wizard)
            case AnswerTag.lived:
                // "Lived?" only: vampire
                handleAnswer(for: .vampire)
            case AnswerTag.threeHundredYears:
                // 300 years only: mermaid
                handleAnswer(for: .mermaid)
            case AnswerTag.oneThousandPlusYears:
                // 1000+ years only: elf
                handleAnswer(for: .elf)
            default:
                assertionFailure("Active tag should correspond to an answer tag.")
            }
        } else if tagsActivated.count == 2 {
            if
                tagsActivated.contains(AnswerTag.lived),
                tagsActivated.contains(AnswerTag.threeHundredYears)
            {
                // "Lived?" + 300 years: vampire
                handleAnswer(for: .vampire)
            } else {
                // Any other two: wizard
                handleAnswer(for: .wizard)
            }
        } else {
            if tagsActivated.contains(AnswerTag.lived) {
               handleAnswer(for: .vampire)
            } else if
                tagsActivated.contains(AnswerTag.threeHundredYears),
                tagsActivated.contains(AnswerTag.oneThousandPlusYears)
            {
                // 300 + 1000:
                //     - is -10 checked: wizard
                //          - else: elf
                if tagsActivated.contains(AnswerTag.negativeTenYears) {
                    handleAnswer(for: .wizard)
                } else {
                    handleAnswer(for: .elf)
                }
            } else {
                // Only black magic could make it this far 😛
                handleAnswer(for: .wizard)
            }
        }
    }

    
}


// MARK: - Private Helper Methods

extension Question2ViewController {
    func submissionStateChanged() {
        switch currentSubmissionState {
        case .submitDisabled:
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.submitButton.isEnabled = false
                self?.submitButton.alpha = 0.5
            })
        case .submitEnabled:
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.submitButton.isEnabled = true
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
