/*:
 ## App Exercise - Finding a Heart Rate
 
 >These exercises reinforce Swift concepts in the context of a fitness tracking app.
 
 Many APIs that give you information gathered by the hardware return optionals. For example, an API for working with a heart rate monitor may give you `nil` if the heart rate monitor is adjusted poorly and cannot properly read the user's heart rate.
 
 Declare a variable `heartRate` of type `Int?` and set it to `nil`. Print the value.
 */
var heartRate: Int? = nil
print(heartRate)

/*:
 In this example, if the user fixes the positioning of the heart rate monitor, the app may get a proper heart rate reading. Below, update the value of `heartRate` to 74. Print the value.
 */
heartRate = 74
print(heartRate)

/*:
 As you've done in other app exercises, create a variable `hrAverage` of type `Int` and use the values stored below and the value of `heartRate` to calculate an average heart rate.
 */
let oldHR1 = 80
let oldHR2 = 76
let oldHR3 = 79 
let oldHR4 = 70

var heartRates = [oldHR1, oldHR2, oldHR3, oldHR4]

if let newHeartRate = heartRate {
    heartRates.append(newHeartRate)
}

let totalHeartRate = heartRates.reduce(0) { (sum, current) -> Int in
    return sum + current
}

print("Average heart rate: \(totalHeartRate / heartRates.count)")


//: [Previous](@previous)  |  page 2 of 6  |  [Next: Exercise - Functions and Optionals](@next)
