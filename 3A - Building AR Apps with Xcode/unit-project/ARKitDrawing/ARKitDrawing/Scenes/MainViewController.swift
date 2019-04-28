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
        didSet { objectPlacementModeChanged() }
    }
    
    var currentPlaneVisibilityMode: PlaneVisibilityMode = .visible {
        didSet {
            planeNodes.forEach {
                $0.isHidden = currentPlaneVisibilityMode == .hidden ? true : false
            }
        }
    }
    
    var selectedNode: SCNNode?
    var lastNodePlacementPoint: SCNVector3?
    
    var nodeDragPlacementThreshold = CGFloat(10.2)
    var lastDragPlacementPoint: SCNVector3?
    
    private var planeNodes: [SCNNode] = []
    private var placedNodes: [SCNNode] = []
}


// MARK: - Computed Properties

extension MainViewController {
    var sceneRootNode: SCNNode {
        return sceneView.scene.rootNode
    }
    
    var detectionReferenceImages: Set<ARReferenceImage>? {
        if currentObjectPlacementMode == .image {
            return ARReferenceImage.referenceImages(
                // inGroupNamed: R.ARReferenceImages,
                inGroupNamed: "AR Resources",
                bundle: nil
            )
        } else {
            return nil
        }
    }
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
        
        reloadSessionConfig()
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
            let nodeToPlace = selectedNode,
            let touch = touches.first
        else { return }
        
        switch currentObjectPlacementMode {
        case .freeform:
            addNodeInFrontOfCamera(nodeToPlace)
        case .image:
            break  // TODO: Implement
        case .plane:
            if let contactPoint = planeContactPoint(from: touch) {
                nodeToPlace.position = contactPoint
                makePlacement(of: nodeToPlace, on: sceneRootNode)
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard
            currentObjectPlacementMode == .plane,
            let nodeToPlace = selectedNode,
            let touch = touches.first
        else { return }
        
        if let contactPoint = planeContactPoint(from: touch) {
            if
                lastDragPlacementPoint == nil ||
                SCNVector3.distanceBetween(contactPoint, and: lastDragPlacementPoint!) > nodeDragPlacementThreshold
            {
                nodeToPlace.position = contactPoint
                lastDragPlacementPoint = contactPoint
                makePlacement(of: nodeToPlace, on: sceneRootNode)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        lastDragPlacementPoint = nil
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
        placedNodes.forEach { $0.removeFromParentNode() }
        placedNodes.removeAll(keepingCapacity: true)
        
        planeNodes.forEach { $0.removeFromParentNode() }
        planeNodes.removeAll(keepingCapacity: true)
        
        reloadSessionConfig(options: [.removeExistingAnchors])
    }
}


// MARK: - Private Helper Methods

private extension MainViewController {
    
    func setupSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    
    func reloadSessionConfig(options: ARSession.RunOptions = []) {
        worldTrackingConfig.planeDetection = [.horizontal]
        worldTrackingConfig.detectionImages = detectionReferenceImages
        
        sceneView.session.run(worldTrackingConfig, options: options)
    }
    
    
    /**
     Sets the transform of a given node to be 20cm in from of the camera,
     then adds it to the scene.
     */
    func addNodeInFrontOfCamera(_ node: SCNNode, byDistanceOf distance: Float = 0.3) {
        guard let currentFrame = sceneView.session.currentFrame else { return }
        
        node.simdTransform = transformFrom(camera: currentFrame.camera, x: 0, y: 0, z: -distance)
        makePlacement(of: node, on: sceneRootNode)
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
    
    
    func planeContactPoint(from touch: UITouch) -> SCNVector3? {
        let touchPoint = touch.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(touchPoint, types: [.existingPlaneUsingExtent])
        
        if let match = hitTestResults.first {
            let worldTransform = match.worldTransform

            return SCNVector3(
                x: worldTransform.columns.3.x,
                y: worldTransform.columns.3.y,
                z: worldTransform.columns.3.z
            )
        }
        
        return nil
    }
    
    
    func objectPlacementModeChanged() {
        reloadSessionConfig()
        
        switch currentObjectPlacementMode {
        case .freeform, .image:
            currentPlaneVisibilityMode = .hidden
        case .plane:
            currentPlaneVisibilityMode = .visible
        }
    }
}

