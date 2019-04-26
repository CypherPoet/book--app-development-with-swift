//
//  SceneSelectionItem.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/25/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation
import ARKit

struct SceneSelectionItem {
    static var resourceFolderName = "Models.scnassets"

    var directoryName: String
    var fileName: String
    var description: String
    
    
    init(
        directoryName: String,
        fileName: String,
        description: String = ""
    ) {
        self.directoryName = directoryName
        self.fileName = fileName
        self.description = description
    }
}

extension SceneSelectionItem {
    static var resourceFolderURL: URL? {
        return Bundle.main.url(forResource: SceneSelectionItem.resourceFolderName, withExtension: nil)
    }
    
    var rootNode: SCNNode? {
        let scene = SCNScene(
            named: "\(directoryName)/\(fileName)",
            inDirectory: SceneSelectionItem.resourceFolderName,
            options: nil
        )
        
        return scene?.rootNode
    }
}
