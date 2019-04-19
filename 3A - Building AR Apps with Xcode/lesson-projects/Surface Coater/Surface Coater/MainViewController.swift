//
//  MainViewController
//  Surface Coater
//
//  Created by Brian Sipple on 4/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    lazy var worldTrackingConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
     
        configuration.planeDetection = [.horizontal, .vertical]
        
        return configuration
    }()
}


// MARK: - Lifecycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSceneView()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Run the view's session
        sceneView.session.run(worldTrackingConfiguration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}



// MARK: - Private Helper Methods

private extension MainViewController {
    func setupSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    
    func makePlaneSurface(size planeSize: CGSize, alignment: ARPlaneAnchor.Alignment) -> SCNNode {
        let geometry = SCNPlane(width: planeSize.width, height: planeSize.height)
        let node = SCNNode(geometry: geometry)
        
        switch alignment {
        case .horizontal:
            node.eulerAngles.x = -.pi / 2
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        case .vertical:
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        @unknown default:
            fatalError("Attempting to handle unknown plane alignment")
        }
        
        node.opacity = 0.25
        
        return node
    }
}


// MARK: - ARSCNViewDelegate

extension MainViewController {
    
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
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        print("Adding node for \(planeAnchor.alignment == .horizontal ? "horizontal" : "vertical") anchor")

        let planeSize = CGSize(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeSurface = makePlaneSurface(size: planeSize, alignment: planeAnchor.alignment)
            
        node.addChildNode(planeSurface)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        print("Updating plane anchor")
        
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
