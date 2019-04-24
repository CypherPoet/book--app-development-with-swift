//
//  NewShapeViewController.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import ARKit

class NewShapeViewController: UIViewController {
    @IBOutlet weak var selectedGeometryTextField: UITextField!
    @IBOutlet weak var selectedColorTextField: UITextField!
    @IBOutlet weak var selectedSizeTextField: UITextField!
    @IBOutlet var shapeSettingTextFields: [UITextField]!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    enum FieldTag: Int {
        case geometry = 1
        case color = 2
        case size = 3
    }
    
    private var geometryPickerDataSource: PickerViewDataSource<String>!
    private var colorPickerDataSource: PickerViewDataSource<String>!
    private var sizePickerDataSource: PickerViewDataSource<String>!
    
    var shape: SCNNode?
    
    lazy var optionsPicker: UIPickerView = {
        let picker = UIPickerView()
        
        picker.delegate = self
        
        return picker
    }()
}


// MARK: - Computed Properties

extension NewShapeViewController {
    
    var geometrySelection: NewShapeSetting.Geometry? {
        return NewShapeSetting.Geometry(rawValue: selectedGeometryTextField.text ?? "")
    }

    
    var colorSelection: NewShapeSetting.Color? {
        return NewShapeSetting.Color(rawValue: selectedColorTextField.text ?? "")
    }
    
    
    var sizeSelection: NewShapeSetting.Size? {
        return NewShapeSetting.Size(rawValue: selectedSizeTextField.text ?? "")
    }

    
    var canSaveShape: Bool {
        return shapeSettingTextFields.allSatisfy { $0.hasText }
    }
}
    

// MARK: - Lifecycle

extension NewShapeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPickerDataSources()
        setupUI()
    }
}


// MARK: - Event handling

extension NewShapeViewController {
    
    @IBAction func shapeFieldEditingBegan(_ sender: UITextField) {
        guard let fieldTag = FieldTag(rawValue: sender.tag) else {
            preconditionFailure("Unknown tag for input field")
        }
        
        switch fieldTag {
        case .geometry:
            optionsPicker.dataSource = geometryPickerDataSource
        case .color:
            optionsPicker.dataSource = colorPickerDataSource
        case .size:
            optionsPicker.dataSource = sizePickerDataSource
        }
    }
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        closeOptionsPicker()
    }
}


// MARK: - Navigation

extension NewShapeViewController {
    
    /**
     Attempt to create, then expose, the final SCNNode object created
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        shape = createNodeFromOptions()
    }
}


// MARK: - UIPickerViewDelegate

extension NewShapeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let dataSource = optionsPicker.dataSource as? PickerViewDataSource<String> else {
            preconditionFailure("Unable to read data source for picker")
        }
        
        return dataSource.options[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let dataSource = optionsPicker.dataSource as? PickerViewDataSource<String> else {
            preconditionFailure("Unable to read data source for picker")
        }
        
        let selection = dataSource.options[row]
        
        switch dataSource {
        case geometryPickerDataSource:
            selectedGeometryTextField.text = selection
        case colorPickerDataSource:
            selectedColorTextField.text = selection
        case sizePickerDataSource:
            selectedSizeTextField.text = selection
        default:
            break
        }
    }
}



// MARK: - Private Helper Methods

private extension NewShapeViewController {
    
    func setupPickerDataSources() {
        self.geometryPickerDataSource = PickerViewDataSource(
            options: NewShapeSetting.Geometry.allCases.map { $0.rawValue.capitalized }
        )
        
        self.colorPickerDataSource = PickerViewDataSource(
            options: NewShapeSetting.Color.allCases.map { $0.rawValue.capitalized }
        )
        
        self.sizePickerDataSource = PickerViewDataSource(
            options: NewShapeSetting.Size.allCases.map { $0.rawValue.capitalized }
        )
    }
    
    
    func setupUI() {
        shapeSettingTextFields.forEach { $0.inputView = optionsPicker }
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(NewShapeViewController.viewTapped(gestureRecognizer:))
            )
        )
    }
    
    
    func closeOptionsPicker() {
        view.endEditing(true)
        saveButton.isEnabled = canSaveShape
    }
    
    
    func createNodeFromOptions() -> SCNNode? {
        guard
            let geometrySelection = geometrySelection,
            let colorSelection = colorSelection,
            let sizeSelection = sizeSelection
        else {
            preconditionFailure("Failed to read selections required to make shape")
        }
        
        let geometry = makeGeometry(from: geometrySelection, withSize: sizeSelection)
        
//        geometry.firstMaterial?.diffuse.contents = UIColor(colorSelection)
        
        let shapeNode = SCNNode(geometry: geometry)
        
        return shapeNode
    }
    
    
    func makeGeometry(
        from geometrySelection: NewShapeSetting.Geometry,
        withSize sizeSelection: NewShapeSetting.Size
    ) -> SCNGeometry {
        // TODO: Figure out for realz
        return SCNGeometry()
    }
}


