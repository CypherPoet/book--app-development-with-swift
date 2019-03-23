/*:
 ## Exercise - Functions and Optionals
 
 If an app asks for a user's age, it may be because the app requires a user to be over a certain age to use some of the services it provides. Write a function called `checkAge` that takes one parameter of type `String`. The function should try to convert this parameter into an `Int` value and then check if the user is over 18 years old. If he/she is old enough, print "Welcome!", otherwise print "Sorry, but you aren't old enough to use our app." If the `String` parameter cannot be converted into an `Int` value, print "Sorry, something went wrong. Can you please re-enter your age?" Call the function and pass in `userInputAge` below as the single parameter. Then call the function and pass in a string that can be converted to an integer.
 */
let userInputAge: String = "34e"

if let validatedAge = Int(userInputAge) {
    if validatedAge > 18 {
        print("Welcome!")
    } else {
        print("Sorry, we're agist")
    }
} else {
    print("Invalid input")
}

/*:
 Imagine you are creating an app for making purchases. Write a function that will take the name of an item for purchase and will return the cost of that item. In the body of the function, check to see if the item is in stock by accessing it in the dictionary `stock`. If it is, return the price of the item by accessing it in the dictionary `prices`. If the item is out of stock, return `nil`. Call the function and pass in a `String` that exists in the dictionaries below. Print the return value.
 */
var prices = ["Chips": 2.99, "Donuts": 1.89, "Juice": 3.99, "Apple": 0.50, "Banana": 0.25, "Broccoli": 0.99]
var stock = ["Chips": 4, "Donuts": 0, "Juice": 12, "Apple": 6, "Banana": 6, "Broccoli": 3]


typealias Satoshis = Double

func findPrice(for itemName: String) -> Satoshis? {
    if let stock = stock[itemName] {
        if let price = prices[itemName] {
            return price
        }
    }
    
    return nil
}

print("Price of chips: \(findPrice(for: "Chips")!)")
print("Price of apples: \(findPrice(for: "Apple")!)")

//: [Previous](@previous)  |  page 3 of 6  |  [Next: App Exercise - Food Functions](@next)
