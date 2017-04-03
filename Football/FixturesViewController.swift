//
//  FixturesViewController.swift
//  Football
//
//  Created by MbProRetina on 4/3/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class FixturesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
    }
}
