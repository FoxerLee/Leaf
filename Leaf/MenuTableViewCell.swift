//
//  MenuTableViewCell.swift
//  Leaf
//
//  Created by 李源 on 03/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
