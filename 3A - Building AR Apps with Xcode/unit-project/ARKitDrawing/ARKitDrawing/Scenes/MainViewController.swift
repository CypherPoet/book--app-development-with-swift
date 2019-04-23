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
    func optionsMenu(_: OptionsMenuViewController, didSelectObject object: SCNNode) {
//        sceneView.scene.addChildNode(object)
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

extension MainViewController {
    
    func setupSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showWorldOrigin]
    }
    
    func makeWorldTrackingConfig() -> ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        
        return config
    }
}
