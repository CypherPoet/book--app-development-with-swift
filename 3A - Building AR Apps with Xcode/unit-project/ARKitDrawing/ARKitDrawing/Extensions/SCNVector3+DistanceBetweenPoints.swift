//
//  SCNVector3+DistanceFromPoint.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    static func distanceBetween(_ pointA: SCNVector3, and pointB: SCNVector3) -> CGFloat {
        let xDistance = pointA.x - pointB.x
        let yDistance = pointA.y - pointB.y
        let zDistance = pointA.z - pointB.z
        
        return CGFloat(
            (xDistance * xDistance) +
            (yDistance * yDistance) +
            (zDistance * zDistance)
        ).squareRoot()
    }
}


