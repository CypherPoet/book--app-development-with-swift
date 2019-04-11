//
//  ViewController.swift
//  SceneKit Primitives
//
//  Created by Brian Sipple on 4/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class HomeViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!

    lazy var scene = SCNScene(named: "art.scnassets/campus.scn")
    lazy var sceneConfiguration = ARWorldTrackingConfiguration()
    
    lazy var buildingPosition = SCNVector3(x: 0.0, y: 0.0, z: -4.0)
    let buildingWidth = Float(3.0)
    let buildingLength = Float(1.0)
    let buildingHeight = Float(1.0)
    
    // 📝 Toggle this to switch between building with code and building with IB
    let isUsingInterfaceBuilder = false
}


// MARK: - Lifecycle

extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        setupScene()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(sceneConfiguration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

}


// MARK: - Computed Properties

extension HomeViewController {
    var treePositions: [SCNVector3] {
        let yPosition = buildingPosition.y + (buildingHeight / 4)
        let startX = buildingPosition.x - (buildingWidth / 2) - 0.5
        let startZ = buildingPosition.z + (buildingLength / 2) + 0.5
        let spacing = buildingWidth / 10
        
        var positions: [SCNVector3] = []
        
        for i in 1...10 {
            positions.append(SCNVector3(
                x: startX + (spacing * Float(i)),
                y: yPosition,
                z: startZ
            ))
        }
        
        for i in 1...10 {
            positions.append(SCNVector3(
                x: startX + (spacing * Float(i)),
                y: yPosition,
                z: startZ + (buildingLength + 0.35)
            ))
        }
        
        return positions
    }
}



// MARK: - Private Helper Methods

private extension HomeViewController {
    func setupScene() {
        
        if !isUsingInterfaceBuilder {
            sceneView.scene = makeSceneWithNodes()
        } else {
            guard let scene = SCNScene(named: "art.scnassets/campus.scn") else {
                preconditionFailure("Failed to load scene from .scn file")
            }
            
            sceneView.scene = scene
        }
    }
    
    
    func makeSceneWithNodes() -> SCNScene {
        let scene = SCNScene()
        
        let building = makeMainBuilding()
        
        scene.rootNode.addChildNode(building)
        makeTrees().forEach { scene.rootNode.addChildNode($0) }
        
        return scene
    }
    
    
    func makeMainBuilding() -> SCNNode {
        let geometry = SCNBox(width: CGFloat(buildingWidth), height: 1.0, length: CGFloat(buildingLength), chamferRadius: 0.0)
        geometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.648858428, green: 0.5630133748, blue: 0.8757100105, alpha: 1)
        
        let building = SCNNode(geometry: geometry)
        building.position = buildingPosition
        
        building.addChildNode(makeSidewalk(for: building))
        building.addChildNode(makeGrass(for: building))
        
        return building
    }
    
    
    func makeSidewalk(for building: SCNNode) -> SCNNode {
        let geometry = SCNPlane(width: 3.5, height: 1.5)
        geometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.799818337, green: 0.8347958326, blue: 0.785923183, alpha: 1)
        geometry.firstMaterial?.isDoubleSided = true
        
        let node = SCNNode(geometry: geometry)
        node.eulerAngles.x = -.pi / 2

        // Ideally, we'd have a more organized way organizing these
        // dimensions so we could reference other dimensions we're
        // basing them off of 🙂.
        node.position = SCNVector3(x: 0.0, y: -0.5, z: 0.0)
        
        return node
    }
    
    
    func makeGrass(for building: SCNNode) -> SCNNode {
        let geometry = SCNPlane(width: 7, height: 5.5)
        geometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0, green: 0.3921216726, blue: 0, alpha: 1)
        geometry.firstMaterial?.isDoubleSided = true
        
        let node = SCNNode(geometry: geometry)
        node.eulerAngles.x = -.pi / 2
        node.position = SCNVector3(x: 0.0, y: -0.501, z: 0.0)
        
        return node
    }
    
    
    func makeTrees() -> [SCNNode] {
        return treePositions.map { makeTree(at: $0) }
    }
    
    
    func makeTree(at position: SCNVector3) -> SCNNode {
        let tree = SCNNode()
        tree.position = position
        
        let trunkGeometry = SCNCylinder(radius: 0.1, height: 1)
        trunkGeometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.1409398019, green: 0.08611593395, blue: 0.03211989254, alpha: 1)
        
        let trunkNode = SCNNode(geometry: trunkGeometry)
        trunkNode.position = tree.position
        trunkNode.position.y = tree.position.y - 0.5
        
        let topGeometry = SCNSphere(radius: 0.24)
        topGeometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.4659774303, green: 1, blue: 0, alpha: 1)
        
        let topNode = SCNNode(geometry: topGeometry)
        topNode.position = tree.position
        
        tree.addChildNode(trunkNode)
        tree.addChildNode(topNode)
        
        return tree
    }
}



// MARK: - ARSCNViewDelegate

extension HomeViewController: ARSCNViewDelegate {
    
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
