//
//  ViewController.swift
//  ARKit From Single-View Template
//
//  Created by Brian Sipple on 4/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class HomeViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    lazy var scene = SCNScene(named: "art.scnassets/ship.scn")
    lazy var sceneConfiguration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupSceneView()
    }
}


// MARK: - Lifecycle

extension HomeViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(sceneConfiguration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}



// MARK: - Private Helper Methods

private extension HomeViewController {

    func setupSceneView() {
        guard let scene = scene else {
            fatalError("Unable to load SCNScene")
        }
        
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
}


// MARK: - ARSCNViewDelegate

extension HomeViewController: ARSCNViewDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
}
