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


// MARK: - Computed Properties

extension MainViewController {
    
    var waitAndRemoveAction: SCNAction {
        return SCNAction.sequence([
            .wait(duration: 5.0),
            .fadeOut(duration: 2.0),
            .removeFromParentNode(),
        ])
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
        sceneView.debugOptions = [.showFeaturePoints, .showBoundingBoxes]
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
    
    
    func makeImageCovering(from referenceImage: ARReferenceImage) -> SCNNode {
        let geometry = SCNPlane(
            width: referenceImage.physicalSize.width,
            height: referenceImage.physicalSize.height
        )
        geometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.5524958772, green: 0.3723448692, blue: 0.9544175863, alpha: 1)
        
        let node = SCNNode(geometry: geometry)
        
        node.eulerAngles.x = -.pi / 2
        node.opacity = 0.3
        
        let labelGeometry = SCNText(string: referenceImage.name, extrusionDepth: 3.0)
        let labelNode = SCNNode(geometry: labelGeometry)
        
        labelNode.position = SCNVector3(x: Float(node.frame.midX), y: Float(node.frame.minY), z: 1.0)
        
        node.addChildNode(labelNode)
        
        return node
    }
    
    
    func nodeAdded(_ node: SCNNode, for planeAnchor: ARPlaneAnchor) {
        // TODO: Handle plane detection
    }
    
    
    func nodeAdded(_ node: SCNNode, for imageAnchor: ARImageAnchor) {
        print("Adding surface for image anchor")
        
        let referenceImage = imageAnchor.referenceImage
        
        node.addChildNode(makeImageCovering(from: referenceImage))
        node.runAction(waitAndRemoveAction)
    }
}
