//
//  StoryboardID.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum StoryboardID {
    enum Segue {
        static let showShapeSelectionView = "Show Shape Selection View"
        static let showSceneSelectionView = "Show Scene Selection View"
        static let popoverToOptionsMenu = "Popover to Options Menu"
        static let unwindToOptionsAfterSceneSelect = "Unwind to Options After Scene File Selection"
    }
    
    enum ReuseIdentifier {
        static let optionsMenuCell = "Options Menu Cell"
        static let sceneSelectionCell = "Selected Scene Cell"
    }
}
