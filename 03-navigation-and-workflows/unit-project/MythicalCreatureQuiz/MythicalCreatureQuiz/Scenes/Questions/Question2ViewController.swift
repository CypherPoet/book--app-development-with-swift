//
//  Question2ViewController.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class Question2ViewController: UIViewController {
    lazy var question: Question = makeQuestion()
    
    weak var delegate: QuestionViewControllerDelegate? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension Question2ViewController: QuestionViewController {
    func makeQuestion() -> Question {
        return Question(text: "Question 2")
    }
    
    func handleAnswer(for creature: Creature) {
        delegate?.answerSubmitted(for: question)
    }
    
    
}
