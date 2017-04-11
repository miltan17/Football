//
//  FixtureCell.swift
//  Football
//
//  Created by MbProRetina on 4/11/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class FixtureCell: UITableViewCell {

    @IBOutlet weak var homeTeamName: UILabel!
    
    @IBOutlet weak var awayTeamName: UILabel!
    
    @IBOutlet weak var homeTeamGoal: UILabel!
    
    @IBOutlet weak var awayTeamGoal: UILabel!
    
    @IBOutlet weak var matchTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        homeTeamName.text = "Home"
        awayTeamName.text = "away"
        homeTeamGoal.text = ""
        awayTeamGoal.text = ""
        matchTime.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
