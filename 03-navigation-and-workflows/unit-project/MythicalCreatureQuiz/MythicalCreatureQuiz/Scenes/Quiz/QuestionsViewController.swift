//
//  QuestionsViewController.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/3/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
    @IBOutlet var questionViews: [UIStackView]!
    
    // 📝 For a larger quiz/project, I'd probably have each question be its own view
    // and setup some kind of some kind of navigation, view loading or view-controller containment
    // mechanism
    enum QuestionState {
        case question(number: Int)
        case finished
    }
    
    lazy var creaturePoints: [Creature: Int] = {
        var points: [Creature: Int] = [:]
        
        Creature.allCases.forEach { points[$0] = 0 }
        
        return points
    }()
    
    
    lazy var questionViewControllers: [QuestionViewController] = {
        return [
            Question1ViewController(),
            Question2ViewController(),
        ]
    }()
    
    
    var currentQuestionState: QuestionState = .question(number: 1) {
        didSet { questionStateChanged(from: oldValue) }
    }
    
    
    var activeQuestionViewController: QuestionViewController? = nil {
        didSet {
            oldValue?.handleRemoval()
            
            if let activeQuestionViewController = activeQuestionViewController {
                // TODO: Find frame here?
                add(child: activeQuestionViewController, frame: nil)
            }
        }
    }
}


// MARK: - QuestionViewControllerDelegate

extension QuestionsViewController: QuestionViewControllerDelegate {
    func answerSubmitted(for question: Question) {
        guard let creature = question.answeredFor else {
            return assertionFailure("answered question should have a creature set")
        }
        
        creaturePoints[creature]! += 1
        
        print("Answer submitted for \(creature)")
        
        advanceQuiz()
    }
}


// MARK: - Lifecycle

extension QuestionsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupQuestionControllers()
        currentQuestionState = .question(number: 1)
    }
    
}


// MARK: - Private Helper Methods

private extension QuestionsViewController {
    
    func setupQuestionControllers() {
        for controller in questionViewControllers {
            controller.delegate = self
            
//            addChild(controller)
//            view.addSubview(controller.view)
//            controller.didMove(toParent: self)
        }
        
        activeQuestionViewController = questionViewControllers.first!
    }
    
    
    func setupUI(forQuestion questionNumber: Int) {
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.questionViews.forEach { $0.isHidden = true }
            },
            completion: { [weak self] _ in
                self?.questionViews[questionNumber - 1].isHidden = false
            }
        )
    }
    
    
    func advanceQuiz() {
        switch currentQuestionState {
        case .question(let currentNumber):
            if currentNumber == questionViewControllers.count {
                currentQuestionState = .finished
            } else {
                currentQuestionState = .question(number: currentNumber + 1)
            }
        case .finished:
            assertionFailure("Quiz shouldn't be attempting advance when already finished")
        }
    }
    
    
    func finishQuiz() {
        // activate segue to results and pass along the winner
    }
    
    
    func questionStateChanged(from oldState: QuestionState) {
        switch currentQuestionState {
        case .question(let number):
            activeQuestionViewController = questionViewControllers[number - 1]
        case .finished:
            finishQuiz()
        }
    }
}
