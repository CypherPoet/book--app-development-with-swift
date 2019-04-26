//
//  SelectSceneViewController.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import ARKit

class SelectSceneViewController: UITableViewController {
    var dataSource: TableViewDataSource<SceneSelectionItem>!
    var sceneModel: SCNNode?
}


// MARK: - Lifecycle

extension SelectSceneViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSceneData()
    }
}


// MARK: -  UITableViewDelegate

extension SelectSceneViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sceneItem = dataSource.models[indexPath.row]
        
        sceneModel = sceneItem.rootNode
        performSegue(withIdentifier: StoryboardID.Segue.unwindToOptionsAfterSceneSelect, sender: self)
    }
}



// MARK: - Private Helper Methods

private extension SelectSceneViewController {
    
    func loadSceneData() {
        guard let modelsURL = SceneSelectionItem.resourceFolderURL else {
            preconditionFailure("Unable to make url for model resrouces folder")
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let fileEnumerator = FileManager().enumerator(at: modelsURL, includingPropertiesForKeys: []) else {
                preconditionFailure("Unable to enumerate models at \"\(modelsURL)\"")
            }
            
            let sceneItems: [SceneSelectionItem] = fileEnumerator.compactMap { element in
                guard
                    let url = element as? URL,
                    url.pathExtension == "scn"
                else { return nil }
                
                return SceneSelectionItem(
                    directoryName: url.deletingLastPathComponent().lastPathComponent,
                    fileName: url.lastPathComponent
                )
            }
            
            DispatchQueue.main.async {
                let dataSource = TableViewDataSource(
                    models: sceneItems,
                    cellReuseIdentifier: StoryboardID.ReuseIdentifier.sceneSelectionCell,
                    cellConfigurator: { (sceneItem, cell) in
                        cell.textLabel?.text = sceneItem.fileName
                    }
                )
                
                self?.dataSource = dataSource
                self?.tableView.dataSource = dataSource
                self?.tableView.reloadData()
            }
        }
    }
}
