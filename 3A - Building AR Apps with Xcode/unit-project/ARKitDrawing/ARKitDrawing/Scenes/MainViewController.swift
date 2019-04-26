//
//  MainViewController.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    lazy var worldTrackingConfig: ARWorldTrackingConfiguration = makeWorldTrackingConfig()
    
    var currentObjectPlacementMode: ObjectPlacementMode = .freeform
    var selectedNode: SCNNode?
}


// MARK: - Lifecycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSceneView()
        currentObjectPlacementMode = .freeform
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(worldTrackingConfig)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}


// MARK: - Event handling

extension MainViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard
            let node = selectedNode,
            let touch = touches.first
        else {
            return
        }
        
        switch currentObjectPlacementMode {
        case .freeform:
            addNodeInFront(node)
        case .image:
            break  // TODO: Implement
        case .plane:
            break  // TODO: Implement
        }
    }
    
    
    @IBAction func changeObjectPlacementMode(_ sender: UISegmentedControl) {
        
    }
}


// MARK: - Navigation

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == StoryboardID.Segue.popoverToOptionsMenu,
            let optionsMenuNavigationController = segue.destination as? UINavigationController,
            let optionsMenuVC = optionsMenuNavigationController.children.first as? OptionsMenuViewController
        else {
            return
        }
        
        optionsMenuVC.menuDelegate = self
        
        optionsMenuVC.preferredContentSize = CGSize(
            width: view.frame.width * 0.75,
            height: view.frame.height * 0.75
        )
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


// MARK: -  OptionsViewControllerDelegate

extension MainViewController: OptionsMenuDelegate {
    func optionsMenu(_: OptionsMenuViewController, didSelectNode newNode: SCNNode) {
        print("New node selected: \(newNode.description)")
        
        selectedNode = newNode
        dismiss(animated: true)
    }
    
    func optionsMenuDidUndoLastObject(_: OptionsMenuViewController) {
        // remove most recent object from scene
    }
    
    func optionsMenuDidTogglePlaneVizualization(_: OptionsMenuViewController) {
        //
    }
    
    func optionsMenuDidResetScene(_: OptionsMenuViewController) {
        // clear nodes from scene
    }
}


// MARK: - Private Helper Methods

private extension MainViewController {
    
    func setupSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showWorldOrigin]
    }
    
    
    func makeWorldTrackingConfig() -> ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        
        return config
    }
    
    
    /**
     Sets the transform of a given node to be 20cm in from of the camera,
     then adds it to the scene.
     */
    func addNodeInFront(_ node: SCNNode) {
        guard let currentFrame = sceneView.session.currentFrame else { return }
        
        node.simdTransform = transformFrom(camera: currentFrame.camera, x: 0, y: 0, z: -0.2)

        // 🔑 Use a clone to allow for placing multiple copies
        sceneView.scene.rootNode.addChildNode(node.clone())
    }
    
    
    func transformFrom(camera: ARCamera, x: Float, y: Float, z: Float) -> simd_float4x4 {
        var offsettingTransform = matrix_identity_float4x4
        
        offsettingTransform.columns.3.x = x
        offsettingTransform.columns.3.y = y
        offsettingTransform.columns.3.z = z
        
        return matrix_multiply(camera.transform, offsettingTransform)
    }
}
