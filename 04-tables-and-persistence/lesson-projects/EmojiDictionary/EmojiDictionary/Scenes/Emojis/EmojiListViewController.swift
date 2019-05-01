//
//  EmojiListViewController.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class EmojiListViewController: UITableViewController {
    lazy var emojiListModelController = EmojiListModelController()
    
    var dataSource: TableViewDataSource<Emoji>!
}


// MARK: - Lifecycle

extension EmojiListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
    }
}


// MARK: - Computeds

extension EmojiListViewController {
    
}


// MARK: - Private Helper Methods

private extension EmojiListViewController {
    
    func setupData() {
        emojiListModelController.start { [weak self] (emojis) in
            let dataSource = TableViewDataSource(
                models: emojis,
                cellReuseIdentifier: StoryboardID.ReuseIdentifier.emojiTableCell,
                cellConfigurator: { (emoji, cell) in
//                    cell.configure(with: emoji.tableCellViewModel)   // 🔑 MVVM for custom cells might have us doing something like this
                    cell.textLabel?.text = emoji.name
                    cell.detailTextLabel?.text = emoji.description
                }
            )
            
            DispatchQueue.main.async {
                self?.dataSource = dataSource
                self?.tableView.dataSource = dataSource
                self?.tableView.reloadData()
            }
        }
    }
    
    
//    func loadEmojis() {
//        emojiManager.load() { [weak self] (emojis) in
//            let dataSource = TableViewDataSource(
//                models: emojis,
//                cellReuseIdentifier: StoryboardID.ReuseIdentifier.emojiTableCell,
//                cellConfigurator: { (emoji, cell) in
//
//                }
//            )
//
//            self?.dataSource = dataSource
//            self?.tableView.dataSource = dataSource
//        }
//    }
}
