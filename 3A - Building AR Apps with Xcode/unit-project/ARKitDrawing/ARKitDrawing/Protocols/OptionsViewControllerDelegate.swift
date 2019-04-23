//
//  OptionsMenuDelegate.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import ARKit

protocol OptionsMenuDelegate {
    func optionsMenu(_: OptionsMenuViewController, didSelectObject object: SCNNode)
    func optionsMenuDidUndoLastObject(_: OptionsMenuViewController)
    func optionsMenuDidTogglePlaneVizualization(_: OptionsMenuViewController)
    func optionsMenuDidResetScene(_: OptionsMenuViewController)
}
