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
    @IBOutlet var settingTextFields: [UITextField]!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    enum FieldTag: Int {
        case geometry = 1
        case color = 2
        case size = 3
    }
    
    private var geometryPickerDataSource: PickerViewDataSource<NewShapeSetting.Geometry>!
    private var colorPickerDataSource: PickerViewDataSource<NewShapeSetting.Color>!
    private var sizePickerDataSource: PickerViewDataSource<NewShapeSetting.Size>!
    
    private var currentGeometrySetting: NewShapeSetting.Geometry? = .box {
        didSet {
            selectedGeometryTextField.text = currentGeometrySetting?.rawValue.capitalized ?? ""
        }
    }
    
    private var currentColorSetting: NewShapeSetting.Color? = .blue {
        didSet {
            selectedColorTextField.text = currentColorSetting?.rawValue.capitalized ?? ""
        }
    }
    
    private var currentSizeSetting: NewShapeSetting.Size? = .small {
        didSet {
            selectedSizeTextField.text = currentSizeSetting?.rawValue.capitalized ?? ""
        }
    }
    
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
        let text = selectedGeometryTextField.text ?? ""
        
        return NewShapeSetting.Geometry(rawValue: text.lowercased())
    }

    
    var colorSelection: NewShapeSetting.Color? {
        let text = selectedColorTextField.text ?? ""
        
        return NewShapeSetting.Color(rawValue: text.lowercased())
    }
    
    
    var sizeSelection: NewShapeSetting.Size? {
        let text = selectedSizeTextField.text ?? ""
        
        return NewShapeSetting.Size(rawValue: text.lowercased())
    }

    
    var canSaveShape: Bool {
        return settingTextFields.allSatisfy { $0.hasText }
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
     Attempt to create, then expose, the final SCNNode shape
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        shape = createNodeFromOptions()
    }
}


// MARK: - UIPickerViewDelegate

extension NewShapeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSourceValue(forRow: row)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.dataSource {
        case let dataSource as PickerViewDataSource<NewShapeSetting.Geometry>:
            currentGeometrySetting = row == 0 ? nil : dataSource.options[row - 1]
        case let dataSource as PickerViewDataSource<NewShapeSetting.Color>:
            currentColorSetting = row == 0 ? nil : dataSource.options[row - 1]
        case let dataSource as PickerViewDataSource<NewShapeSetting.Size>:
            currentSizeSetting = row == 0 ? nil : dataSource.options[row - 1]
        default:
            preconditionFailure("Unable to read data source for picker")
        }
        
        saveButton.isEnabled = canSaveShape
    }
}


// MARK: - Private Helper Methods

private extension NewShapeViewController {
    
    func setupPickerDataSources() {
        self.geometryPickerDataSource = PickerViewDataSource(
            options: NewShapeSetting.Geometry.allCases
        )
        
        self.colorPickerDataSource = PickerViewDataSource(
            options: NewShapeSetting.Color.allCases
        )
        
        self.sizePickerDataSource = PickerViewDataSource(
            options: NewShapeSetting.Size.allCases
        )
    }
    
    
    func setupUI() {
        settingTextFields.forEach {
            $0.inputView = optionsPicker
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: $0.frame.height))
            $0.leftViewMode = .always
        }
        
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
            let geometrySetting = currentGeometrySetting,
            let colorSetting = currentColorSetting,
            let sizeSetting = currentSizeSetting
        else {
            return nil
        }
        
        let geometry = makeGeometry(from: geometrySetting, withSize: sizeSetting)
        geometry.firstMaterial?.diffuse.contents = colorSetting.uiColor
        
        let node = SCNNode(geometry: geometry)
        node.name = NewShapeSetting.nodeName(fromSettings: (geometrySetting, colorSetting, sizeSetting))
        
        return node
    }
    

    func makeGeometry(
        from geometrySelection: NewShapeSetting.Geometry,
        withSize sizeSelection: NewShapeSetting.Size
    ) -> SCNGeometry {
        let meters = CGFloat(sizeSelection.meters)
        
        switch geometrySelection {
        case .box:
            return SCNBox(width: meters, height: meters, length: meters, chamferRadius: 0.0)
        case .cone:
            return SCNCone(topRadius: 0.0, bottomRadius: meters, height: meters)
        case .cylinder:
            return SCNCylinder(radius: meters / 2, height: meters)
        case .sphere:
            return SCNSphere(radius: meters)
        case .torus:
            return SCNTorus(ringRadius: meters * 1.5, pipeRadius: meters * 0.2)
        case .pyramid:
            return SCNPyramid(width: meters, height: meters * 1.5, length: meters)
        }
    }
    
    
    func dataSourceValue(forRow row: Int) -> String {
        switch optionsPicker.dataSource {
        case let dataSource as PickerViewDataSource<NewShapeSetting.Geometry>:
            return row == 0 ? "" : dataSource.options[row - 1].rawValue.capitalized
        case let dataSource as PickerViewDataSource<NewShapeSetting.Color>:
            return row == 0 ? "" : dataSource.options[row - 1].rawValue.capitalized
        case let dataSource as PickerViewDataSource<NewShapeSetting.Size>:
            return row == 0 ? "" : dataSource.options[row - 1].rawValue.capitalized
        default:
            preconditionFailure("Unable to read data source for picker")
        }
    }
}


