//
//  QuestionViewController.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

protocol QuestionViewController: UIViewController {
    var question: Question { get set }
    var delegate: QuestionViewControllerDelegate? { get set }
    
    func handleAnswer(for creature: Creature)
}
