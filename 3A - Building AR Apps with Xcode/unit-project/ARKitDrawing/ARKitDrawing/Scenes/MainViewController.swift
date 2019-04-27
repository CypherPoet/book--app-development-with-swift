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
    
    lazy var worldTrackingConfig = ARWorldTrackingConfiguration()
    
    var currentObjectPlacementMode: ObjectPlacementMode = .freeform {
        didSet { setWorldTrackingConfig() }
    }
    
    var currentPlaneVisibilityMode: PlaneVisibilityMode = .visible {
        didSet {
            planeNodes.forEach {
                $0.isHidden = currentPlaneVisibilityMode == .visible ? true : false
            }
        }
    }
    
    var selectedNode: SCNNode?
    
    private var placedNodes: [SCNNode] = []
    private var planeNodes: [SCNNode] = []
}


// MARK: - Lifecycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSceneView()
        currentObjectPlacementMode = .freeform
        currentPlaneVisibilityMode = .visible
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setWorldTrackingConfig()
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
    
    
    func anchorNodeAdded(_ anchorNode: SCNNode, for imageAnchor: ARImageAnchor) {
        guard let selectedNode = selectedNode else {
            print("Detected image, but no node is selected")
            return
        }
        print("Placing node for image")
        makePlacement(of: selectedNode, on: anchorNode)
    }
    
    
    func anchorNodeAdded(_ anchorNode: SCNNode, for planeAnchor: ARPlaneAnchor) {
        let floor = createFloor(at: planeAnchor)
        
        anchorNode.addChildNode(floor)
        planeNodes.append(floor)
    }
    
    
    @IBAction func changeObjectPlacementMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentObjectPlacementMode = .freeform
        case 1:
            currentObjectPlacementMode = .plane
        case 2:
            currentObjectPlacementMode = .image
        default:
            preconditionFailure("Unknown object placement mode selected")
        }
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        switch anchor {
        case let planeAnchor as ARPlaneAnchor:
            anchorNodeAdded(node, for: planeAnchor)
        case let imageAnchor as ARImageAnchor:
            anchorNodeAdded(node, for: imageAnchor)
        default:
            print("A node was added, but not for an `ARPlaneAnchor` or `ARImageAnchor`")
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if
            let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let planeGeometry = planeNode.geometry as? SCNPlane
        {
            resize(node, at: planeAnchor, using: planeGeometry)
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


// MARK: -  OptionsViewControllerDelegate

extension MainViewController: OptionsMenuDelegate {
    func optionsMenu(_: OptionsMenuViewController, didSelectNode newNode: SCNNode) {
        print("New node selected: \(newNode.description)")
        
        selectedNode = newNode
        dismiss(animated: true)
    }
    
    
    func optionsMenuDidUndoLastObject(_: OptionsMenuViewController) {
        if let lastPlacedNode = placedNodes.popLast() {
            lastPlacedNode.removeFromParentNode()
        }
    }
    
    
    func optionsMenuDidTogglePlaneVizualization(_: OptionsMenuViewController) {
        dismiss(animated: true)
        currentPlaneVisibilityMode = currentPlaneVisibilityMode == .visible ? .hidden : .visible
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
    
    
    func setWorldTrackingConfig() {
        worldTrackingConfig.planeDetection = [.horizontal]
        
        if currentObjectPlacementMode == .image {
            worldTrackingConfig.detectionImages = ARReferenceImage.referenceImages(
//                inGroupNamed: R.ARReferenceImages,
                inGroupNamed: "AR Resources",
                bundle: nil
            )
        } else {
            worldTrackingConfig.detectionImages = nil
        }
    }
    
    
    /**
     Sets the transform of a given node to be 20cm in from of the camera,
     then adds it to the scene.
     */
    func addNodeInFront(_ node: SCNNode) {
        guard let currentFrame = sceneView.session.currentFrame else { return }
        
        node.simdTransform = transformFrom(camera: currentFrame.camera, x: 0, y: 0, z: -0.3)
        makePlacement(of: node, on: sceneView.scene.rootNode)
    }
    
    
    func transformFrom(camera: ARCamera, x: Float, y: Float, z: Float) -> simd_float4x4 {
        var offsettingTransform = matrix_identity_float4x4
        
        offsettingTransform.columns.3.x = x
        offsettingTransform.columns.3.y = y
        offsettingTransform.columns.3.z = z
        
        return matrix_multiply(camera.transform, offsettingTransform)
    }
    
    
    func makePlacement(of node: SCNNode, on targetNode: SCNNode) {
        // 🔑 Use a clone to allow for placing multiple copies
        let clone = node.clone()
        
        targetNode.addChildNode(clone)
        placedNodes.append(clone)
    }
    
    
    func createFloor(at planeAnchor: ARPlaneAnchor) -> SCNNode {
        let size = CGSize(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let geometry = SCNPlane(width: size.width, height: size.height)
        
        geometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.5524958772, green: 0.3723448692, blue: 0.9544175863, alpha: 1)
        
        let node = SCNNode(geometry: geometry)
        
        node.opacity = 0.3
        node.eulerAngles.x = -.pi / 2
        node.isHidden = currentPlaneVisibilityMode == .hidden
        
        return node
    }
    
    
    func resize(_ planeNode: SCNNode, at planeAnchor: ARPlaneAnchor, using planeGeometry: SCNPlane) {
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        planeGeometry.width = CGFloat(planeAnchor.extent.x)
        planeGeometry.height = CGFloat(planeAnchor.extent.z)
    }
}
