//
//  Question3ViewController.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class Question3ViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    lazy var question: Question = Question(
        number: 3,
        text: "On a scale of 0 to 10, how would you rate your tolerance to sunlight?"
    )
    
    weak var delegate: QuestionViewControllerDelegate? = nil
    
    var currentSliderValue = 0 {
        didSet { sliderValueLabel.text = String(currentSliderValue) }
    }
}


// MARK: - Computed Properties

extension Question3ViewController {

}


// MARK: - Lifecycle

extension Question3ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = question.text
    }
}


// MARK: - Event handling

extension Question3ViewController {

    @IBAction func sliderChanged(_ slider: UISlider) {
        currentSliderValue = Int(slider.value)
    }
    
    
    @IBAction func submitButtonTapped(_ button: UIButton) {
        switch currentSliderValue {
        case 0:
            handleAnswer(for: .vampire)
        case 1...5:
            handleAnswer(for: .elf)
        case 6...7:
            handleAnswer(for: .mermaid)
        case 8...10:
            handleAnswer(for: .vampire)
        default:
            assertionFailure("Slider should only run from 0 to 10.")
        }
    }
}


// MARK: - Private Helper Methods

extension Question3ViewController {

}



// MARK: - QuestionViewController

extension Question3ViewController: QuestionViewController {
    func handleAnswer(for creature: Creature) {
        question.answeredFor = creature
        delegate?.answerSubmitted(for: question)
    }
}
