//
//  QuestionViewController.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

protocol QuestionViewControllerDelegate: AnyObject {
    func answerSubmitted(for question: Question)
}
