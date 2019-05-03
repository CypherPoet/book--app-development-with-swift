//
//  EmojiTableViewCell.swift
//  EmojiDictionary
//
//  Created by Brian Sipple on 5/2/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    func configure(with viewModel: EmojiTableCellViewModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
