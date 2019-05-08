//
//  MainViewController.swift
//  SystemViewControllers
//
//  Created by Brian Sipple on 5/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI


class MainViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var safariViewControllerConfig: SFSafariViewController.Configuration = {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        return config
    }()
}


// MARK: - Computed Properties

extension MainViewController {
    
    var imagePickerActions: [UIAlertAction] {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        var actions: [UIAlertAction] = []
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actions.append(UIAlertAction(title: "Use Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actions.append(UIAlertAction(title: "Pick from Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }))
        }
        
        return actions
    }
    
}


// MARK: - Lifecycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


// MARK: - Event handling

extension MainViewController {
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        presentActivityViewController(anchoredAt: sender)
    }
    
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        presentSafariViewController()
    }
    
    
    @IBAction func photosButtonTapped(_ sender: UIButton) {
        presentPhotoPrompt(anchoredAt: sender)
    }
    

    @IBAction func emailButtonTapped(_ sender: UIButton) {
        presentEmailController()
    }
}


// MARK: - UIImagePickerControllerDelegate

extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true)
    }
    
}


// MARK: - UINavigationControllerDelegate

extension MainViewController: UINavigationControllerDelegate {}


// MARK: - MFMailComposeViewControllerDelegate

extension MainViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        dismiss(animated: true)
    }
    
}


// MARK: - Private Helper Methods

private extension MainViewController {

    func presentActivityViewController(anchoredAt popoverTarget: UIView) {
        guard let image = imageView.image else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        activityViewController.popoverPresentationController?.sourceView = popoverTarget
        
        present(activityViewController, animated: true)
    }
    
    
    func presentSafariViewController() {
        guard let url = URL(string: "https://apple.com") else {
            fatalError("Failed to make url for safari")
        }
        
        let safariViewController = SFSafariViewController(url: url, configuration: safariViewControllerConfig)
        
        present(safariViewController, animated: true)
    }
    
    
    func presentPhotoPrompt(anchoredAt popoverTarget: UIView) {
        let alertController = UIAlertController(title: "Choose an Image Source", message: nil, preferredStyle: .actionSheet)
        
        imagePickerActions.forEach { alertController.addAction($0) }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.popoverPresentationController?.sourceView = popoverTarget
        present(alertController, animated: true)
    }
    
    
    func presentEmailController() {
        guard MFMailComposeViewController.canSendMail() else {
            print("Can't send mail!")
            return
        }
        
        let mailController = MFMailComposeViewController()
        
        mailController.mailComposeDelegate = self
        
        mailController.setToRecipients(["CypherPoet@gmail.com"])
        mailController.setSubject("Look at this!")
        mailController.setMessageBody("👋 Hello!\n\nThis is an email from the app I made.", isHTML: false)
        
        present(mailController, animated: true)
    }
}
