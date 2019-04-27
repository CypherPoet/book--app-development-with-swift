//
//  OptionsContainerViewController.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class OptionsMenuViewController: UITableViewController {
    var menuDelegate: OptionsMenuDelegate!
    var dataSource: OptionsMenuTableViewDataSource!
    
    lazy var menuItems: [OptionsMenuItem] = makeMenuItems()
}


// MARK: - Lifecycle

extension OptionsMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard menuDelegate != nil else {
            preconditionFailure("Attempting to load OptionsMenuViewController without a `menuDelegate`")
        }
        
        setupMenu()
    }
}


// MARK: - Navigation

extension OptionsMenuViewController {
    @IBAction func cancelAddShape(unwindSegue: UIStoryboardSegue) {}
    @IBAction func cancelAddScene(unwindSegue: UIStoryboardSegue) {}

    
    @IBAction func saveShape(unwindSegue: UIStoryboardSegue) {
        guard let newShapeVC = unwindSegue.source as? NewShapeViewController else {
            return
        }
        
        if let newShape = newShapeVC.shape {
            menuDelegate.optionsMenu(self, didSelectNode: newShape)
        } else {
            assertionFailure("No shape created after `NewShapeViewController` attempted to save one")
        }
    }
    
    
    @IBAction func saveScene(unwindSegue: UIStoryboardSegue) {
        guard let selectSceneVC = unwindSegue.source as? SelectSceneViewController else {
            return
        }
        
        if let sceneModel = selectSceneVC.sceneModel {
            menuDelegate.optionsMenu(self, didSelectNode: sceneModel)
        } else {
            assertionFailure("No scene model created after `SelectSceneViewController` attempted to save one")
        }
    }
}



// MARK: -  UITableViewDelegate

extension OptionsMenuViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = dataSource.models[indexPath.row]
        
        switch option.optionFor {
        case .addBasicShape:
            performSegue(withIdentifier: StoryboardID.Segue.showShapeSelectionView, sender: self)
        case .addScene:
            performSegue(withIdentifier: StoryboardID.Segue.showSceneSelectionView, sender: self)
        case .togglePlaneVizualization:
            menuDelegate.optionsMenuDidTogglePlaneVizualization(self)
        case .undoLastShape:
            menuDelegate.optionsMenuDidUndoLastObject(self)
        case .resetScene:
            menuDelegate.optionsMenuDidResetScene(self)
        }
    }
}


// MARK: - Private Helper Methods

private extension OptionsMenuViewController {
    
    func setupMenu() {
        dataSource = OptionsMenuTableViewDataSource(
            models: menuItems,
            cellReuseIdentifier: StoryboardID.ReuseIdentifier.optionsMenuCell
        )
        
        tableView.dataSource = dataSource
    }
    

    func makeMenuItems() -> [OptionsMenuItem] {
        return [
            OptionsMenuItem(title: "Select Basic Shape", hasDisclosureIndicator: true, optionFor: .addBasicShape),
            OptionsMenuItem(title: "Add Scene File", hasDisclosureIndicator: true, optionFor: .addScene),
            OptionsMenuItem(title: "Enable/Disable Plane Visualization", hasDisclosureIndicator: false, optionFor: .togglePlaneVizualization),
            OptionsMenuItem(title: "Undo Last Object", hasDisclosureIndicator: false, optionFor: .undoLastShape),
            OptionsMenuItem(title: "Reset Scene", hasDisclosureIndicator: false, optionFor: .resetScene),
        ]
    }
}

