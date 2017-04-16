//
//  fixtureTableCell.swift
//  Football
//
//  Created by MbProRetina on 4/12/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class fixtureTableCell: UITableViewCell {

    @IBOutlet weak var homeTeamName: UILabel!
    
    @IBOutlet weak var awayTeamName: UILabel!
    
    @IBOutlet weak var homeTeamGoal: UILabel!
    
    @IBOutlet weak var awayTeamGoal: UILabel!
    
    @IBOutlet weak var matchDate: UILabel!
    
    @IBOutlet weak var matchTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        homeTeamName.text = ""
        awayTeamName.text = ""
        homeTeamGoal.text = "3"
        awayTeamGoal.text = ""
        matchDate.text = ""
        matchTime.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
