//
//  FixturesViewController.swift
//  Football
//
//  Created by MbProRetina on 4/3/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit
import Foundation

class FixturesViewController: UIViewController {
    
    var fixture = [[String: AnyObject]](){
        didSet{
            print("Data Found")
        }
    }
    
    var fixtureData = [Date: [AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
 
        DispatchQueue.main.async {
            self.getJsonData()
        }
    }
    
    private func getJsonData(){
        RestAPIManager.sharedInstance.getFixtureInfo{ responseDictionary  in
            self.fixture = responseDictionary["fixtures"] as! [[String : AnyObject]]
            for fixture in self.fixture{
                for (key, value) in fixture{
                    if key == "date"{
                        var date = self.findDateOnly(value as! String)
                        if self.fixtureData.keys.contains(date){
                            self.fixtureData[date]?.append(fixture as AnyObject)
                        }else{
                            print("Not Found \(date)")
                            self.fixtureData[date] = [fixture as AnyObject]
                        }
                    }
                }
            }
        }
    }
    
    private func findDateOnly(_ dateANDtime: String) -> Date{
        var fullDateArr = dateANDtime.components(separatedBy: "T")
        let date: String = fullDateArr[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter.date(from: date)!
    }
    
    
    
    
    
}
