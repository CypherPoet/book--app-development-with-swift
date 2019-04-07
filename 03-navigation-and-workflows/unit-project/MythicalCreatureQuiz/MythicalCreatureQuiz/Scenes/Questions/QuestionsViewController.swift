//
//  QuestionsViewController.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/3/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
    weak var delegate: QuestionViewControllerDelegate!
    
    lazy var questionViewControllers: [QuestionViewController] = {
        return [
            Question1ViewController(),
            Question2ViewController(),
            Question3ViewController(),
        ]
    }()
    
    
    var currentQuestionNumber = 1 {
        didSet { questionNumberChanged(from: oldValue) }
    }
    
    
    var activeQuestionViewController: QuestionViewController? = nil {
        didSet {
            oldValue?.handleRemoval()
            
            if let activeQuestionViewController = activeQuestionViewController {
                add(child: activeQuestionViewController, frame: view.safeAreaLayoutGuide.layoutFrame)
            }
        }
    }
}


// MARK: - Lifecycle

extension QuestionsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupQuestionControllers()
        currentQuestionNumber = 1
    }
    
}


// MARK: - Private Helper Methods

private extension QuestionsViewController {
    
    func setupQuestionControllers() {
        questionViewControllers.forEach { $0.delegate = self }
        activeQuestionViewController = questionViewControllers.first!
    }
    
    
    func questionNumberChanged(from oldQuestion: Int) {
        guard currentQuestionNumber <= questionViewControllers.count else {
            return assertionFailure("Quiz attempted to advance beyond available questions.")
        }
        
        activeQuestionViewController = questionViewControllers[currentQuestionNumber - 1]
    }
}


// MARK: - QuestionViewControllerDelegate

extension QuestionsViewController: QuestionViewControllerDelegate {
    func answerSubmitted(for question: Question) {
        print("Answer submitted for question \(question.number)")
        
        if question.number < questionViewControllers.count {
            currentQuestionNumber += 1
        }
        
        delegate.answerSubmitted(for: question)
    }
}
