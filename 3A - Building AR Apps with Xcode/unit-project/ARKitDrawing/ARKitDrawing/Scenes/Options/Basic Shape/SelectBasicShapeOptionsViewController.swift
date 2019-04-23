//
//  SelectBasicShapeOptionsViewController.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class SelectBasicShapeOptionsViewController: UIViewController {
    @IBOutlet weak var selectedGeometryTextField: UITextField!
    
    enum FieldTag: Int {
        case geometry = 1
        case color = 2
        case size = 3
    }
    
    
    private let geometryOptions = ["Box", "Sphere", "Cylinder", "Cone", "Torus"]
    private var geometryPickerDataSource: PickerViewDataSource<String>!
    
    private let colorOptions = ["Red", "Yellow", "Orange", "Green", "Blue", "Brown", "White", "Purple"]
    private var colorPickerDataSource: PickerViewDataSource<String>!
    
    private let sizeOptions = ["Small", "Medium", "Large"]
    private var sizePickerDataSource: PickerViewDataSource<String>!
    
    
    lazy var optionsPicker: UIPickerView = {
        let picker = UIPickerView()
        
        picker.delegate = self
        
        return picker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPickerDataSources()
        setupUI()
    }
    


    @IBAction func geometryFieldEditingBegan(_ sender: UITextField) {
        guard let fieldTag = FieldTag(rawValue: sender.tag) else {
            preconditionFailure("Unknown tag for input field")
        }
        
        switch fieldTag {
        case .geometry:
            optionsPicker.dataSource = geometryPickerDataSource
        case .size:
            optionsPicker.dataSource = sizePickerDataSource
        case .color:
            optionsPicker.dataSource = colorPickerDataSource
        }
    }
}


// MARK: - Event handling

extension SelectBasicShapeOptionsViewController {
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        closeOptionsPicker()
    }
}


// MARK: - UIPickerViewDelegate

extension SelectBasicShapeOptionsViewController: UIPickerViewDelegate {
    
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
        
        switch dataSource {
        case geometryPickerDataSource:
            selectedGeometryTextField.text = dataSource.options[row]
        default:
            break
        }
    }
}



// MARK: - Private Helper Methods

private extension SelectBasicShapeOptionsViewController {
    
    func setupPickerDataSources() {
        self.geometryPickerDataSource = PickerViewDataSource(options: geometryOptions)
        self.colorPickerDataSource = PickerViewDataSource(options: colorOptions)
        self.sizePickerDataSource = PickerViewDataSource(options: sizeOptions)
    }
    
    
    func setupUI() {
        selectedGeometryTextField.inputView = optionsPicker
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        )
    }
    
    
    func closeOptionsPicker() {
        view.endEditing(true)
        
        // TODO: Process final selection? (Or use a submit button?)
    }
}


