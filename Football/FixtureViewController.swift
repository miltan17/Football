//
//  FixtureViewController.swift
//  Football
//
//  Created by MbProRetina on 4/12/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class FixtureViewController: UIViewController {

    
    var leagueInformation = [String: AnyObject]()
    
    var fixtureURL: String?
    
    var fixture = [[String: AnyObject]](){
        didSet{
            print("Data Found")
        }
    }
    
    var fixtureData = [Int: [AnyObject]]()
    
    var fixtureSectionArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initFixtureURL()
        loadFixtureData()
    }

    private func initFixtureURL(){
        let links:[String: AnyObject] = leagueInformation["_links"]! as! [String : AnyObject]
        let fixtures: [String: AnyObject] = links["fixtures"] as! [String : AnyObject]
        fixtureURL = fixtures["href"] as! String?
        print(fixtures["href"]!)
    }
    
    private func loadFixtureData(){
        let apiInstance = RestAPIManager.sharedInstance
        apiInstance.setLeagueTableAddress(address: fixtureURL!)
        apiInstance.getLeaguesPointTableInfo{ responseJSON  in

            self.fixture = responseJSON["fixtures"] as! [[String : AnyObject]]
            for fixture in self.fixture{
                for (key, value) in fixture{
                    if key == "matchday"{
                        let matchDay = value as! Int
                        if self.fixtureData.keys.contains(matchDay){
                            self.fixtureData[matchDay]?.append(fixture as AnyObject)
                        }else{
                            self.fixtureData[matchDay] = [fixture as AnyObject]
                        }
                    }
                }
            }
            self.findFixtureSectionName()
        }
    }
    
    
    private func findFixtureSectionName(){
        for key in fixtureData.keys{
            self.fixtureSectionArray.append(key)
        }
        fixtureSectionArray.sort()
    }
    
}
