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
        case pyramid
    }
    
    enum Size: String, CaseIterable {
        case small
        case medium
        case large
        case extraLarge = "Extra Large"
        
        var meters: Double {
            switch self {
            case .small:
                return 0.033
            case .medium:
                return 0.1
            case .large:
                return 0.3
            case .extraLarge:
                return 0.6
            }
        }
    }
}



extension NewShapeSetting {
    typealias NewShapeSettings = (geometry: NewShapeSetting.Geometry, color: NewShapeSetting.Color, size: NewShapeSetting.Size)
    
    static func nodeName(fromSettings settings: NewShapeSettings) -> String {
        let size = settings.size.rawValue
        let geometry = settings.geometry.rawValue
        let color = settings.color.rawValue
        
        return "\(size) \(geometry) with a \(color) color"
    }
}
