import Foundation
/*:
 ## Exercise - While Loops
 
 Create a while loop that simulates rolling a 6-sided dice repeatedly until a 1 is rolled. After each roll, print the value. (Hint: use `Int(arc4random_uniform(6) + 1)` to generate a random number between 1 and 6).
 */
var roll = Int.random(in: 1 ..< 6)

while roll != 1 {
    print("Rolled a \(roll)")
    roll = Int.random(in: 1 ..< 6)
}


//: [Previous](@previous)  |  page 3 of 6  |  [Next: App Exercise - While Loops](@next)
