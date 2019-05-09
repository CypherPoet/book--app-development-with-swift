//
//  MainViewController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
}


// MARK: - Lifecycle

extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


// MARK: - Navigation

extension MainViewController {
    
    @IBAction func unwindFromCancelCreateBooking(unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func unwindFromSaveCreateBooking(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: Use R.Swift to get id
        guard
            segue.identifier == R.segue.mainViewController.presentCreateBookingForm.identifier,
            let navigationController = segue.destination as? UINavigationController,
            let createBookingVC = navigationController.children.first as? CreateBookingViewController
        else { return }
        
        let modelController = CreateBookingModelController()
        
        createBookingVC.modelController = modelController    
    }
}
