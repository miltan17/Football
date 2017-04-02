//
//  FirstTableCell.swift
//  Football
//
//  Created by MbProRetina on 4/2/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class FirstTableCell: UITableViewCell {
    
    @IBOutlet weak var winsLabel: UILabel!
    
    @IBOutlet weak var lossesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
