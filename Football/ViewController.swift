//
//  ViewController.swift
//  Football
//
//  Created by MbProRetina on 3/20/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    @IBAction func backButtonClick(_ sender: UIBarButtonItem) {
        
    }
}

