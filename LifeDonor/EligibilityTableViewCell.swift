//
//  EligibilityTableViewCell.swift
//  LifeDonor
//
//  Created by iOS Developer on 25/08/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

import UIKit

class EligibilityTableViewCell: UITableViewCell {

    @IBOutlet weak var eligibleImageViw: UIImageView!
    @IBOutlet weak var eligibleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
