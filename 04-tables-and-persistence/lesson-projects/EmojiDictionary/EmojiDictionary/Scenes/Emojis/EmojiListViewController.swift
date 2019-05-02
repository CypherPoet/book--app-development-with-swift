//
//  EmojiListViewController.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class EmojiListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var emojiListModelController = EmojiListModelController()
    
    var dataSource: SectionedTableViewDataSource!
}


// MARK: - Lifecycle

extension EmojiListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        setupData()
        setupTableView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    
}


// MARK: - Computeds

extension EmojiListViewController {
    var viewModel: EmojiListViewModel {
        return emojiListModelController.viewModel
    }
    
    
    var emojiDataSources: [TableViewDataSource<Emoji>] {
        return viewModel.emojiSections.map { .make(for: $0) }
    }
}


// MARK: - UITableViewDelegate

extension EmojiListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}


// MARK: - Private Helper Methods

private extension EmojiListViewController {
    
    func setupData() {
        emojiListModelController.start { [weak self] _ in
            guard let self = self else { return }
            
            let dataSource = SectionedTableViewDataSource(
                dataSources: self.emojiDataSources,
                sectionHeaderTitles: self.viewModel.emojiSectionHeaderTitles
            )
            
            DispatchQueue.main.async {
                self.dataSource = dataSource
                self.tableView.dataSource = dataSource
                self.tableView.reloadData()
            }
        }
    }
    
    
    func setupTableView() {
        tableView.delegate = self
    }
}
