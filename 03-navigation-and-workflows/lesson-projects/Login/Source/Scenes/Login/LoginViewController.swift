//
//  LoginViewController.swift
//  Login
//
//  Created by Brian Sipple on 3/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func inputTextChanged(_ sender: UITextField) {
        loginButton.isEnabled = usernameTextField.hasText && passwordTextField.hasText
    }
}

// MARK: - Navigation

extension LoginViewController {
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let viewController = segue.destination.children.first as? HomeViewController else { return }
        
        // 📝 For user information, we'd probably store this somewhere else and have the
        // HomeViewController find it from there 🙂
        viewController.username = usernameTextField.text
    }
}
