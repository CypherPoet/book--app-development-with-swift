//
//  Question.swift
//  MythicalCreatureQuiz
//
//  Created by Brian Sipple on 4/3/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct Question {
    var number: Int
    var text: String
    var answeredFor: Creature? = nil

    
    init(number: Int, text: String) {
        self.number = number
        self.text = text
    }
}
