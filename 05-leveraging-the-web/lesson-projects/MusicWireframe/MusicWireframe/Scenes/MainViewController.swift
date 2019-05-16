//
//  MainViewController.swift
//  MusicWireframe
//
//  Created by Brian Sipple on 5/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var reverseBackground: UIView!
    @IBOutlet private weak var playPauseBackground: UIView!
    @IBOutlet private weak var forwardBackground: UIView!
    
    @IBOutlet private weak var reverseButton: UIButton!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    
    @IBOutlet private weak var albumImageView: UIImageView!
    
    enum PlayState {
        case playing
        case paused
    }
    
    enum PlayerButtonIdentifier: String {
        case reverse = "Reverse Button"
        case playPause = "Play/Pause Button"
        case forward = "Forward Button"
    }
    
    var currentPlayState: PlayState = .paused {
        didSet { playStateChanged() }
    }
}


// MARK: - Computed Properties

extension MainViewController {
    
    var albumImageViewTransform: CGAffineTransform {
        switch currentPlayState {
        case .paused:
            return CGAffineTransform(scaleX: 0.8, y: 0.8)
        case .playing:
            return CGAffineTransform.identity
        }
    }
    
}


// MARK: - Lifecycle

extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        currentPlayState = .paused
    }
}


// MARK: - Event handling

extension MainViewController {
    
    @IBAction func playerButtonTouchedDown(_ sender: UIButton) {
        guard let identifier = PlayerButtonIdentifier(rawValue: sender.accessibilityIdentifier ?? "") else {
            preconditionFailure("Unknown button touched")
        }
        
        switch identifier {
        case .reverse:
            showButtonBackground(background: reverseBackground, belongingTo: sender)
        case .playPause:
            showButtonBackground(background: playPauseBackground, belongingTo: sender)
        case .forward:
            showButtonBackground(background: forwardBackground, belongingTo: sender)
        }
    }
    
    
    @IBAction func playerButtonTouchedUp(_ sender: UIButton) {
        guard let identifier = PlayerButtonIdentifier(rawValue: sender.accessibilityIdentifier ?? "") else {
            preconditionFailure("Unknown button touched")
        }
        
        switch identifier {
        case .reverse:
            hideButtonBackground(background: reverseBackground, belongingTo: sender)
        case .playPause:
            hideButtonBackground(background: playPauseBackground, belongingTo: sender)
        case .forward:
            hideButtonBackground(background: forwardBackground, belongingTo: sender)
        }
    }
    
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        currentPlayState = currentPlayState == .paused ? .playing : .paused
    }
    
}


// MARK: - Private Helper Methods

private extension MainViewController {
    
    func setupUI() {
        [reverseBackground, playPauseBackground, forwardBackground].forEach { background in
            guard let background = background else {
                preconditionFailure("Failed to find button background view")
            }
            
            background.layer.cornerRadius = background.frame.height / 2.0
            background.clipsToBounds = true
            background.alpha = 0.0
        }
    }

    
    func playStateChanged() {
        switch currentPlayState {
        case .paused:
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        case .playing:
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.albumImageView.transform = self.albumImageViewTransform
            }
        )
    }
    
    
    func showButtonBackground(background backgroundView: UIView, belongingTo button: UIButton) {
        UIView.animate(
            withDuration: 0.225,
            animations: {
                button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                
                backgroundView.alpha = 0.4
            }
        )
    }
    
    
    func hideButtonBackground(background backgroundView: UIView, belongingTo button: UIButton) {
        UIView.animate(
            withDuration: 0.225,
            animations: {
                backgroundView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                backgroundView.alpha = 0.0
                
                button.transform = .identity
            },
            completion: { _ in
                backgroundView.transform = .identity
            }
        )
    }
}

