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
    
   
    var remainingLettersToGuess: Set<Character> {
        didSet {
            if remainingLettersToGuess.isEmpty {
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
        
        state = .playing
        remainingLettersToGuess = Set<Character>(answerToGuess.sorted())
    }
}


// MARK: - Core Methods

extension Game {
    mutating func letterGuessed(_ letter: String) {
        if answerToGuess.contains(letter) {
            remainingLettersToGuess.remove(Character(letter))
        } else {
            mistakesRemaining -= 1
        }
    }
}
