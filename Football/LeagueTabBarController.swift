//
//  LeagueTabBarController.swift
//  Football
//
//  Created by MbProRetina on 4/12/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class LeagueTabBarController: UITabBarController {

    var leagueInformation  = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(leagueInformation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */

}
