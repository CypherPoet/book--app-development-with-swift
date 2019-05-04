//
//  AddEditEmojiViewController.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/3/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class AddEditEmojiViewController: UITableViewController {
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var usageTextView: UITextView!
    @IBOutlet weak var categoryTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var emoji: Emoji?
    
    lazy var categoryPickerView = UIPickerView()
    lazy var categoryPickerViewDataSource = PickerViewDataSource(options: Emoji.Category.allCases)
}


// MARK: - Lifecycle

extension AddEditEmojiViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.delegate = self
        usageTextView.delegate = self
        categoryPickerView.delegate = self
        
        configure(with: emoji)
        setupTableView()
        
        if let emoji = emoji {
            title = "\(emoji.symbol) \(emoji.name)"
        } else {
            title = "New Emoji Entry"
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        categoryPickerView.selectRow(categoryPickerIndex, inComponent: 0, animated: true)
        pickerView(categoryPickerView, didSelectRow: categoryPickerIndex, inComponent: 0)
    }
}


// MARK: - Computed Properties

extension AddEditEmojiViewController {
    
    var canSaveEmoji: Bool {
        return (
            symbolTextField.hasText &&
            nameTextField.hasText &&
            descriptionTextView.hasText &&
            usageTextView.hasText
        )
    }
    
    
    var emojiFromChanges: Emoji {
        return Emoji(
            symbol: symbolTextField.text ?? "",
            name: nameTextField.text ?? "",
            description: descriptionTextView.text ?? "",
            usage: usageTextView.text ?? "",
            category: categoryTextView.text ?? ""
        )
    }
    
    
    var categoryPickerIndex: Int {
        if let emojiCategory = Emoji.Category(rawValue: emoji?.category ?? "") {
            return categoryPickerViewDataSource.options.firstIndex(of: emojiCategory) ?? 0
        } else {
            return 0
        }
    }
}


// MARK: - Event handling

extension AddEditEmojiViewController {
    
    @IBAction func textEditingChanged(_ sender: Any) {
        saveButton.isEnabled = canSaveEmoji
    }
}


// MARK: - Navigation

extension AddEditEmojiViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == StoryboardID.Segue.unwindFromSaveEmoji else { return }
        
        emoji = emojiFromChanges
    }
    
}


// MARK: - UITextViewDelegate

extension AddEditEmojiViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textEditingChanged(textView)
    }
}


// MARK: - UIPickerViewDelegate

extension AddEditEmojiViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerViewDataSource.options[row].rawValue
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextView.text = categoryPickerViewDataSource.options[row].rawValue
        textEditingChanged(pickerView)
    }
}



// MARK: - Private Helper Methods

private extension AddEditEmojiViewController {

    func configure(with emoji: Emoji?) {
        symbolTextField.text = emoji?.symbol ?? ""
        nameTextField.text = emoji?.name ?? ""
        descriptionTextView.text = emoji?.description ?? ""
        usageTextView.text = emoji?.usage ?? ""
        
        categoryPickerView.dataSource = categoryPickerViewDataSource
        categoryTextView.inputView = categoryPickerView
    }
    
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 52
    }
}
