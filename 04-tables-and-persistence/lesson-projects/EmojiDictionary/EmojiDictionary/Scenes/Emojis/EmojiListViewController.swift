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
    
    lazy var viewModel = EmojiListViewModel()
    
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
    var emojiDataSources: [TableViewDataSource<Emoji>] {
        return viewModel.sectionedEmojis.map { emojis in
            return TableViewDataSource(
                models: emojis,
                cellReuseIdentifier: StoryboardID.ReuseIdentifier.emojiTableCell,
                cellConfigurator: { (emoji, cell) in
                    guard let emojiCell = cell as? EmojiTableViewCell else {
                        preconditionFailure("Unknown cell returned for table view configuration: \(cell)")
                    }
                    
                    emojiCell.configure(with: EmojiTableCellViewModel(
                        symbol: emoji.symbol,
                        name: emoji.name,
                        description: emoji.description
                    ))
                },
                modelDeleter: { [weak self] (deletedEmoji, absoluteIndex) in
                    self?.viewModel.delete(deletedEmoji, at: absoluteIndex)
                }
            )
        }
    }
}


// MARK: - Navigation

extension EmojiListViewController {
    
    @IBAction func cancelAddEditEmojiChanges(unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func saveAddEditEmojiChanges(unwindSegue: UIStoryboardSegue) {
        guard
            let addEditEmojiVC = unwindSegue.source as? AddEditEmojiViewController,
            let emoji = addEditEmojiVC.emoji
        else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            update(emoji, at: selectedIndexPath)
        } else {
            add(emoji)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == StoryboardID.Segue.editEmoji,
            let addEditEmojiVC = segue.destination.children.first as? AddEditEmojiViewController,
            let indexPath = tableView.indexPathForSelectedRow,
            let sectionDataSource = dataSource.dataSourceForSection(at: indexPath) as? TableViewDataSource<Emoji>
        else { return }
        
        addEditEmojiVC.emoji = sectionDataSource.models[indexPath.row]
    }
    
}


// MARK: - UITableViewDelegate

extension EmojiListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}


// MARK: - Private Helper Methods

private extension EmojiListViewController {
    
    func setupData() {
        viewModel.start { [weak self] _ in
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
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    func update(_ emoji: Emoji, at selectedIndexPath: IndexPath) {
        let absoluteIndex = tableView.absoluteIndex(forRow: selectedIndexPath.row, inSection: selectedIndexPath.section)
        
        viewModel.update(emoji, at: absoluteIndex) { [weak self] in
            guard let self = self else { return }

            let dataSource = self.dataSource.dataSourceForSection(at: selectedIndexPath) as! TableViewDataSource<Emoji>
                
            dataSource.models[selectedIndexPath.row] = emoji
            self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
    }
    
    
    func add(_ emoji: Emoji) {
        viewModel.add(emoji) { [weak self] (sectionAddedTo, rowAddedAt) in
            guard let self = self else { return }
            
            let newIndexPath = IndexPath(row: rowAddedAt, section: sectionAddedTo)
            
            if let sectionDataSource = self.dataSource.dataSourceForSection(at: newIndexPath) as? TableViewDataSource<Emoji> {
                sectionDataSource.models.insert(emoji, at: newIndexPath.row)
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            } else {
                let newDataSource: TableViewDataSource<Emoji> = .make(for: [emoji])
                
                self.dataSource.add(newDataSource, at: sectionAddedTo, usingHeader: emoji.category)
                self.tableView.insertSections(IndexSet([sectionAddedTo]), with: .automatic)
            }
        }

    }
}
