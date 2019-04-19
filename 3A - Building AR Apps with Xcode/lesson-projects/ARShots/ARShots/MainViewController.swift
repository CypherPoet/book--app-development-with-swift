//
//  MainViewController
//  ARShots
//
//  Created by Brian Sipple on 4/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    enum GameplayState {
        case placingHoop
        case shooting
    }
    
    var currentGameplayState: GameplayState = .placingHoop
    
    lazy var worldTrackingConfiguration: ARWorldTrackingConfiguration = makeWorldTrackingConfig()
    
    lazy var hoopScene = SCNScene(named: "art.scnassets/hoop.scn")
    lazy var hoopNode: SCNNode = getHoopNode()
}


// MARK: - Computed Properties

extension MainViewController {

    /**
        Helper to convert the currentFrame camera's transform matrix
        from a `simd_float4x4` to a `SCNMatrix4`.
     */
    var cameraTransformSCNMatrix: SCNMatrix4 {
        guard let currentFrame = sceneView.session.currentFrame else {
            preconditionFailure("No current frame found in the sceneView session")
        }
        
        return SCNMatrix4(currentFrame.camera.transform)
    }
    
    var ballForce: SCNVector3 {
        let cameraTransform  = cameraTransformSCNMatrix
        let power = Float(10.0)
        
        return SCNVector3(
            x: -cameraTransform.m31 * power,
            y: -cameraTransform.m32 * power,
            z: -cameraTransform.m33 * power
        )
    }
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


// MARK: - Event handling

extension MainViewController {
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        switch currentGameplayState {
        case .placingHoop:
            attemptHoopPlacement(at: sender.location(in: sceneView))
        case .shooting:
            sceneView.scene.rootNode.addChildNode(makeBasketball())
        }
    }
}


// MARK: - Private Helper Methods

private extension MainViewController {
    func setupSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    
    func addHoop(using hitTestResult: ARHitTestResult) {
        let newHoop = hoopNode.clone()
        let planePosition = hitTestResult.worldTransform.columns.3
        
        newHoop.position = SCNVector3(planePosition.x, planePosition.y, planePosition.z)

        newHoop.physicsBody = SCNPhysicsBody(
            type: .static,
            shape: SCNPhysicsShape(
                node: newHoop,
                options: [
                    .type: SCNPhysicsShape.ShapeType.concavePolyhedron,
                ]
            )
        )
        
        sceneView.scene.rootNode.addChildNode(newHoop)
    }
    
    
    func getHoopNode() -> SCNNode {
        guard let hoopNode = hoopScene?
            .rootNode
            .childNode(withName: "Hoop", recursively: false)
        else {
            preconditionFailure("Failed to find hoop node in hoop scene file")
        }
        
        return hoopNode
    }
    
    
    func makeWorldTrackingConfig() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.vertical]
        configuration.isLightEstimationEnabled = true
        
        return configuration
    }
    
    
    func makePlaneSurface(size planeSize: CGSize, alignment: ARPlaneAnchor.Alignment) -> SCNNode {
        let geometry = SCNPlane(width: planeSize.width, height: planeSize.height)
        let surface = SCNNode(geometry: geometry)
        
        geometry.firstMaterial?.isDoubleSided = true
        
        switch alignment {
        case .horizontal:
            geometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 1, green: 0.761900723, blue: 0.2978103757, alpha: 1)
        case .vertical:
            geometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 1, green: 0.3241527379, blue: 0.1405510008, alpha: 1)
            surface.eulerAngles = SCNVector3(x: -.pi / 2.0, y: 0, z: 0)
        @unknown default:
            fatalError("Attempting to handle unknown plane alignment")
        }
        
        surface.opacity = 0.50
        
        return surface
    }
    
    
    func makeBasketball() -> SCNNode {
        print("Making basketball")
        let geometry = SCNSphere(radius: 0.25)
        let ball = SCNNode(geometry: geometry)
        
        geometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.9978941083, green: 0.3908590078, blue: 0.1553532481, alpha: 1)
        ball.transform = cameraTransformSCNMatrix
        
        ball.physicsBody = SCNPhysicsBody(
            type: .dynamic,
            shape: SCNPhysicsShape(
                node: ball,
                options: [                    
                    .collisionMargin: 0.01
                ]
            )
        )
        
        
        ball.physicsBody?.applyForce(ballForce, asImpulse: true)
        
        return ball
    }
    
    
    func attemptHoopPlacement(at touchLocation: CGPoint) {
        let hitTestResults = sceneView.hitTest(touchLocation, types: [.existingPlaneUsingExtent])
        
        if let result = hitTestResults.first {
            print("Ray intersected a discovered plane! 🎯")
            print("Hit test result: \(result)")
            addHoop(using: result)
            currentGameplayState = .shooting
        } else {
            print("Ray interected no planes during hit test")
        }
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
        guard
            let planeAnchor = anchor as? ARPlaneAnchor,
            planeAnchor.alignment == .vertical
        else {
            return
        }
        
        let planeSize = CGSize(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let surface = makePlaneSurface(size: planeSize, alignment: .vertical)
        
        print("Adding node for vertical surface")
        node.addChildNode(surface)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let newPosition = SCNVector3(planeAnchor.center.x, 0.0, planeAnchor.center.z)
        
        for node in node.childNodes {
            node.position = newPosition
            
            if let planeGeometry = node.geometry as? SCNPlane {
                planeGeometry.width = CGFloat(planeAnchor.extent.x)
                planeGeometry.height = CGFloat(planeAnchor.extent.z)
            }
        }
    }
}
