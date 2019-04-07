//
//  QuestionsContainerViewController.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/6/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class QuestionsContainerViewController: UIViewController {
    @IBOutlet weak var quizProgressBar: UIProgressView!
    
    let questionCount = 3  // TODO: Move to Question struct?
    
    
    lazy var creaturePoints: [Creature: Int] = {
        var points: [Creature: Int] = [:]
        
        Creature.allCases.forEach { points[$0] = 0 }
        
        return points
    }()
    
    
    var currentQuizState: QuizState = .question(number: 1) {
        didSet { quizStateChanged() }
    }
}


// MARK: - Lifecycle

extension QuestionsContainerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentQuizState = .question(number: 1)
    }
}


// MARK: - Computed Properties

extension QuestionsContainerViewController {
    var winningCreature: Creature {
        let sortedScores = creaturePoints.sorted {
            (keyValuePairA, keyValuePairB) -> Bool in
            return keyValuePairA.value > keyValuePairB.value
        }
        
        // 📝 A more advanced version would include some tie-breaking functionality here.
        return sortedScores.first!.key
    }
}



// MARK: - Navigation

extension QuestionsContainerViewController {

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case (let questionsVC as QuestionsViewController):
            questionsVC.delegate = self
        case (let resultsVC as ResultsViewController):
            resultsVC.creatureAnswer = winningCreature
        default:
            break
        }
    }
}


// MARK: - Private Helper Methods

private extension QuestionsContainerViewController {
    
    func quizStateChanged() {
        switch currentQuizState {
        case .question(let currentNumber):
            quizProgressBar.setProgress(Float(currentNumber) / Float(questionCount), animated: true)
        case .finished:
            finishQuiz()
        }
    }
    
    
    func finishQuiz() {
        performSegue(withIdentifier: StoryboardID.Segue.showResults, sender: nil)
    }
}


// MARK: - QuestionViewControllerDelegate

extension QuestionsContainerViewController: QuestionViewControllerDelegate {
    func answerSubmitted(for question: Question) {
        guard let creature = question.answeredFor else {
            return assertionFailure("answered question should have a creature set")
        }
        
        creaturePoints[creature]! += 1
        
        print("Answer submitted for question \(question.number): \(creature)")
        
        if question.number < questionCount {
            currentQuizState = .question(number: question.number + 1)
        } else {
            currentQuizState = .finished
        }
    }
}
