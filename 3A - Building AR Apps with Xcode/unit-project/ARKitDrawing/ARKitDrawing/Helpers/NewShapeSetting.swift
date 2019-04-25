//
//  NewShapeSetting.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

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
        
        var uiColor: UIColor {
            guard let color = UIColor(named: self.rawValue.capitalized) else {
                preconditionFailure("Failed to make name color from shape setting")
            }

            return color
        }
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
        
        var meters: Double {
            switch self {
            case .small:
                return 0.33
            case .medium:
                return 1.3
            case .large:
                return 3.0
            }
        }
    }
}

