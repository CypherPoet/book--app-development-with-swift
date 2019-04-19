//
//  MainViewController.swift
//  ARImageFinder
//
//  Created by Brian Sipple on 4/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    lazy var worldTrackingConfig: ARWorldTrackingConfiguration = makeWorldTrackingConfig()
}


// MARK: - Lifecycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
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


// MARK: - ARSCNViewDelegate

extension MainViewController: ARSCNViewDelegate {
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        switch anchor {
        case let planeAnchor as ARPlaneAnchor:
            nodeAdded(node, for: planeAnchor)
        case let imageAnchor as ARImageAnchor:
            nodeAdded(node, for: imageAnchor)
        default:
            print("A node was added, but not for an `ARPlaneAnchor` or `ARImageAnchor`")
        }
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


// MARK: - Private Helper Methods

private extension MainViewController {
    func setupScene() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    
    func makeWorldTrackingConfig() -> ARWorldTrackingConfiguration {
        guard let referenceImages = ARReferenceImage.referenceImages(
            inGroupNamed: "AR Resources", bundle: nil
        ) else {
            preconditionFailure("Failed to load reference images for image detection.")
        }
        
        let config = ARWorldTrackingConfiguration()
        
        config.detectionImages = referenceImages
        config.planeDetection = [.horizontal, .vertical]
        
        return config
    }
    
    
    func nodeAdded(_ node: SCNNode, for planeAnchor: ARPlaneAnchor) {
        // TODO: Handle plane detection
    }
    
    
    func nodeAdded(_ node: SCNNode, for imageAnchor: ARImageAnchor) {
        // TODO: Handle image detection
    }
}
