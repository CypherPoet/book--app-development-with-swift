/*:
 ## Exercise - Type Casting and Inspection
 
 Create a collection of type [Any], including a few doubles, integers, strings, and booleans within the collection. Print the contents of the collection.
 */
let mixBag: [Any] = [33, 2342.923, "What?", true, ["L", "O", "L"]]
print(mixBag)
/*:
 Loop through the collection. For each integer, print "The integer has a value of ", followed by the integer value. Repeat the steps for doubles, strings and booleans.
 */
for item in mixBag {
    if item as? Int != nil {
        print("Int: \(item)")
    }
    
    if item as? Double != nil {
        print("Double: \(item)")
    }
    
    if item as? Bool != nil {
        print("Bool: \(item)")
    }
    
    if item as? String != nil {
        print("String: \(item)")
    }
    
    if item as? [String] != nil {
        print("[String]: \(item)")
    }
}


// We can also make the for-loop itself use a qualifier
for item in mixBag where item as? Int != nil {
    print("Int: \(item)")
}

/*:
 Create a [String : Any] dictionary, where the values are a mixture of doubles, integers, strings, and booleans. Print the key/value pairs within the collection
 */
//let codex: [String: Any] = [
//    "🙂": 1,
//    "🦄": 22.1,
//    "💸": "Fed",
//    "🔑": 17.92323,
//    "⚡️": 8342.2
//]
//
//for (key, value) in codex {
//    print(key)
//    print(value)
//}


/*:
 Create a variable `total2` of type `Double` set to 0. Loop through the collection again, adding up all the integers and doubles. For each string that you come across during the loop, attempt to convert the string into a number, and add that value to the total. Ignore booleans. Print the total.
 */
let codex: [String: Any] = [
    "🙂": 1,
    "🦄": 22.1,
    "💸": "Fed",
    "🔑": 17.92323,
    "⚡️": 8342.2
]


let total = codex.reduce(0.0) { (accumulated, keyValue) -> Double in
    guard
        ["🦄", "⚡️"].contains(keyValue.0),
        let value = keyValue.1 as? Double
    else {
        return accumulated
    }
    
    return accumulated + value
}

print(total)  // 8364.300000000001


//: page 1 of 2  |  [Next: App Exercise - Workout Types](@next)
