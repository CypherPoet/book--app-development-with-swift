//
//  SelectRoomTypeViewController.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class SelectRoomTypeViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var dataSource: TableViewDataSource<RoomType>!

    weak var delegate: SelectRoomTypeViewControllerDelegate!
    var selectedRoomType: RoomType?
}


// MARK: - Lifecycle

extension SelectRoomTypeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard delegate != nil else {
            preconditionFailure("SelectRoomTypeViewController must have a delegate")
        }
        
        setupTableView()
    }
    
}


// MARK: - UITableViewDelegate

extension SelectRoomTypeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRoomType = dataSource.models[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
        delegate.selectRoomTypeViewController(self, didSelectRoomType: selectedRoomType!)
    }
    
}


// MARK: - Private Helper Methods

private extension SelectRoomTypeViewController {
    func setupTableView() {
        tableView.delegate = self
        
        dataSource = makeTableViewDataSource()
        tableView.dataSource = dataSource
    }
    
    
    func makeTableViewDataSource() -> TableViewDataSource<RoomType> {
        return TableViewDataSource(
            models: RoomType.allOptions,
            cellReuseIdentifier: R.reuseIdentifier.roomTypeSelectionCell.identifier,
            cellConfigurator: { [weak self] (model, cell) in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = "\(model.price) Satoshis"
                cell.accessoryType = model == self?.selectedRoomType ? .checkmark : .none
            }
        )
    }
}
