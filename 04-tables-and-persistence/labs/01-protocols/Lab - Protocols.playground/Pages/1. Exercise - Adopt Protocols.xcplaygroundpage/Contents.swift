/*:
 ## Exercise - Adopt Protocols: CustomStringConvertible, Equatable, and Comparable
 
 Create a `Human` class with two properties: `name` of type `String`, and `age` of type `Int`. You'll need to create a memberwise initializer for the class. Initialize two `Human` instances.
 */
import Foundation


class Human: Codable {
    var name: String
    var age: Int
    
//    enum CodingKeys: String, CodingKey {
//        case name
//        case age
//    }
    
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    
//    required convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let name = try container.decode(String.self, forKey: .name)
//        let age = try container.decode(Int.self, forKey: .age)
//
//        self.init(name: name, age: age)
//    }
}

let cypherPoet = Human(name: "CypherPoet", age: 1000)
let loki = Human(name: "Loki", age: 900)

print(cypherPoet)
print(loki)
/*:
 Make the `Human` class adopt the `CustomStringConvertible`. Print both of your previously initialized `Human` objects.
 */
extension Human: CustomStringConvertible {
    var description: String {
        return #"A \#(age)-year-old human named "\#(name)"."#
    }
}

/*:
 Make the `Human` class adopt the `Equatable` protocol. Two instances of `Human` should be considered equal if their names and ages are identical to one another. Print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are equal to eachother (using `==`). Then print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are not equal to eachother (using `!=`).
 */
extension Human: Equatable {
    static func == (lhs: Human, rhs: Human) -> Bool {
        return (
            lhs.age == rhs.age &&
            lhs.name == rhs.name
        )
    }
}


let imposter = Human(name: "CypherPoet", age: 1000)

print(cypherPoet == loki)
print(cypherPoet == imposter)
/*:
 Make the `Human` class adopt the `Comparable` protocol. Sorting should be based on age. Create another three instances of a `Human`, then create an array called `people` of type `[Human]` with all of the `Human` objects that you have initialized. Create a new array called `sortedPeople` of type `[Human]` that is the `people` array sorted by age.
 */
extension Human: Comparable {
    static func < (lhs: Human, rhs: Human) -> Bool {
        return lhs.age < rhs.age
    }
}


let humans = [
    Human(name: "A", age: Int.random(in: 1...300)),
    Human(name: "B", age: Int.random(in: 1...300)),
    Human(name: "C", age: Int.random(in: 1...300)),
    Human(name: "D", age: Int.random(in: 1...300)),
    Human(name: "E", age: Int.random(in: 1...300)),
    Human(name: "F", age: Int.random(in: 1...300)),
]


print(humans.sorted())
/*:
 Make the `Human` class adopt the `Codable` protocol. Create a `JSONEncoder` and use it to encode as data one of the `Human` objects you have initialized. Then use that `Data` object to initialize a `String` representing the data that is stored, and print it to the console.
 */
let encoder = JSONEncoder()
let jsonData = try encoder.encode(cypherPoet)

print(String(decoding: jsonData, as: UTF8.self))

//: page 1 of 5  |  [Next: App Exercise - Printable Workouts](@next)
