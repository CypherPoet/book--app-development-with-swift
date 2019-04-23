//
//  SelectBasicShapeOptionsViewController.swift
//  ARKitDrawing
//
//  Created by Brian Sipple on 4/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class SelectBasicShapeOptionsViewController: UIViewController {
    @IBOutlet weak var shapeOptionPicker: UIPickerView!
    @IBOutlet weak var selectedGeometryLabel: UILabel!
    @IBOutlet weak var selectedColorLabel: UILabel!
    
    private let geometryOptions = ["Box", "Sphere", "Cylinder", "Cone", "Torus"]
    private var geometryPickerDataSource: PickerViewDataSource<String>!
    
    private let colorOptions = ["Red", "Yellow", "Orange", "Green", "Blue", "Brown", "White", "Purple"]
    private var colorPickerDataSource: PickerViewDataSource<String>!
    
    private let sizeOptions = ["Small", "Medium", "Large"]
    private var sizePickerDataSource: PickerViewDataSource<String>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPickerDataSources()
    }
    

    @IBAction func selectionLabelTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


// MARK: - Private Helper Methods

private extension SelectBasicShapeOptionsViewController {
    
    func setupPickerDataSources() {
        self.geometryPickerDataSource = PickerViewDataSource(options: geometryOptions)
        self.colorPickerDataSource = PickerViewDataSource(options: colorOptions)
        self.sizePickerDataSource = PickerViewDataSource(options: sizeOptions)
    }
}
