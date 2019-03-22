//
//  Game.swift
//  Apple Pie
//
//  Created by Brian Sipple on 3/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct Game {
    enum State {
        case playing
        case lost
        case won
    }
    
    var answerToGuess: String
    var state: State
    
   
    var currentAnswer: String {
        didSet {
            if currentAnswer != answerToGuess {
                mistakesRemaining -= 1
            } else {
                state = .won
            }
        }
    }
    
    var mistakesRemaining: Int {
        didSet {
            if mistakesRemaining == 0 {
                state = .lost
            }
        }
    }
    
    
    init(answerToGuess: String, guessesRemaining: Int) {
        self.answerToGuess = answerToGuess
        self.mistakesRemaining = guessesRemaining
        
        self.state = .playing
        self.currentAnswer = ""
    }
}
