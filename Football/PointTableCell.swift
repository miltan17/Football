//
//  PointTableCell.swift
//  Football
//
//  Created by MbProRetina on 4/2/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class PointTableCell: UITableViewCell {

    @IBOutlet weak var rank: UILabel!
        
    @IBOutlet weak var team: UILabel!
    
    @IBOutlet weak var playedGame: UILabel!
    
    @IBOutlet weak var goalDifference: UILabel!
    
    @IBOutlet weak var goalAgainst: UILabel!
    
    @IBOutlet weak var goals: UILabel!
    
    @IBOutlet weak var points: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
