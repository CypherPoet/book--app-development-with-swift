//
//  ViewController.swift
//  ContestEntry
//
//  Created by Brian Sipple on 5/16/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    
}


// MARK: - Event handling

extension RegistrationViewController {
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if emailTextField.hasText {
            performSegue(withIdentifier: "Show Success View", sender: self)
        } else {
            shake(textField: emailTextField)
        }
    }
}



// MARK: - Lifecycle

extension RegistrationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}


// MARK: - Private Helper Methods

private extension RegistrationViewController {
    
    func shake(textField: UITextField) {
        let shakeDuration = 0.25
        let originalBorderWidth = textField.layer.borderWidth
        let originalBorderColor = textField.layer.borderColor
        
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 4
        
        UIView.animate(
            withDuration: shakeDuration / 20,
            delay: 0,
            options: [.autoreverse],
            animations: {
                UIView.setAnimationRepeatCount(20)
                textField.transform = CGAffineTransform(rotationAngle: .pi / 48)
            }
//            completion: { _ in
//                UIView.animate(
//                    withDuration: shakeDuration / 20,
//                    animations: {
//                        textField.transform = CGAffineTransform(rotationAngle: -.pi / 48)
//                    }
//                )
//            }
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + shakeDuration) {
            UIView.animate(
                withDuration: shakeDuration / 20,
                animations: {
                    textField.transform = .identity
                    textField.layer.borderWidth = originalBorderWidth
                    textField.layer.borderColor = originalBorderColor
                }
            )
        }
    }
    
}
