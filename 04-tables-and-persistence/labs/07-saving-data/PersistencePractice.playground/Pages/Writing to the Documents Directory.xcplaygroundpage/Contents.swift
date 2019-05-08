//: [Previous](@previous)

import Foundation



func save(note: Note, tofile fileURL: URL) {
//    let encoder = PropertyListEncoder()
    let encoder = JSONEncoder()
    
    guard let noteData = try? encoder.encode(note) else {
        fatalError("Failed to encode note data")
    }
    
    try? noteData.write(to: fileURL, options: .noFileProtection)
    
    
    if let savedNoteData = try? Data(contentsOf: fileURL) {
//        let decoder = PropertyListDecoder()
        let decoder = JSONDecoder()
        
        if let savedNote = try? decoder.decode(Note.self, from: savedNoteData) {
            print(savedNote)
        }
    }
}


func save(notes: [Note], tofile fileURL: URL) {
//    let encoder = PropertyListEncoder()
    let encoder = JSONEncoder()
    
    guard let noteData = try? encoder.encode(notes) else {
        fatalError("Failed to encode note data")
    }
    
    try? noteData.write(to: fileURL, options: .noFileProtection)
    
    
    if let savedNoteData = try? Data(contentsOf: fileURL) {
//        let decoder = PropertyListDecoder()
        let decoder = JSONDecoder()
        
        if let savedNote = try? decoder.decode([Note].self, from: savedNoteData) {
            print(savedNote)
        }
    }
}



let pathExtension = "json"

let archiveURL = FileManager
    .documentsDirectory()
    .appendingPathComponent("notes-test")
    .appendingPathExtension(pathExtension)


let note1 = Note(title: "Swift 1", text: "All the Swift 1", timestamp: Date())
let note2 = Note(title: "Swift 2", text: "All the Swift 2", timestamp: Date())
let note3 = Note(title: "Swift 3", text: "All the Swift 3", timestamp: Date())
let note4 = Note(title: "Swift 4", text: "All the Swift 4", timestamp: Date())
let note5 = Note(title: "Swift 5", text: "All the Swift 5", timestamp: Date())


// save(note: note1, tofile: archiveURL)

save(
    notes: [note1, note2, note3, note4, note5],
    tofile: archiveURL
)



//: [Next](@next)
