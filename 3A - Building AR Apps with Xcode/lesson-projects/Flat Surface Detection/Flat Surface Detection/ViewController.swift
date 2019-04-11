//
//  ViewController.swift
//  Flat Surface Detection
//
//  Created by Brian Sipple on 4/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    lazy var worldTrackingConfig = makeWorldTrackingConfig()
}


extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSceneView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Run the view's session
        sceneView.session.run(worldTrackingConfig)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}


private extension ViewController {
    func setupSceneView() {
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
    }
    
    
    func makeWorldTrackingConfig() -> ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        
        config.planeDetection = [.horizontal]
        
        return config
    }
    
    
    func makeFloor(size: CGSize) -> SCNNode {
        let geometry = SCNPlane(width: size.width, height: size.height)
        let floor = SCNNode(geometry: geometry)
        
        floor.eulerAngles.x = -.pi / 2
        floor.opacity = 0.25
        
        return floor
    }
    
    
    func makeFighterJet() -> SCNNode {
        guard let jetScene = SCNScene(named: "art.scnassets/ship.scn") else {
            preconditionFailure("Failed to load scene for fighter jet")
        }
        
        return jetScene.rootNode.clone()
    }
}


// MARK: - ARSCNViewDelegate

extension ViewController {
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        print("Node for plane anchor added to the scene.\nAnchor: \(planeAnchor)")
        
        let planeSize = CGSize(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let floorPlane = makeFloor(size: planeSize)
        let fighterJet = makeFighterJet()
        
        fighterJet.position.x = planeAnchor.center.x
        fighterJet.position.z = planeAnchor.center.z
        
        node.addChildNode(fighterJet)
        node.addChildNode(floorPlane)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        let newPosition = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        
        for node in node.childNodes {
            node.position = newPosition
            
            if let planeGeometry = node.geometry as? SCNPlane {
                planeGeometry.width = CGFloat(planeAnchor.extent.x)
                planeGeometry.height = CGFloat(planeAnchor.extent.z)
            }
        }
    }
}
