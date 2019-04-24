//
//  NewShapeSetting.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum NewShapeSetting {
    enum Color: String, CaseIterable {
        case red
        case yellow
        case orange
        case green
        case blue
        case brown
        case white
        case purple
        case special
    }
    
    enum Geometry: String, CaseIterable {
        case box
        case sphere
        case cylinder
        case cone
        case torus
    }
    
    enum Size: String, CaseIterable {
        case small
        case medium
        case large
    }
}

