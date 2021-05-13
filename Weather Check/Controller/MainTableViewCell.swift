//
//  MainTableViewCell.swift
//  Weather Check
//
//  Created by Onur Mavitas on 12.05.2021.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
