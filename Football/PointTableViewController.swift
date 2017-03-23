//
//  PointTableViewController.swift
//  Football
//
//  Created by MbProRetina on 3/22/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class PointTableViewController: UIViewController {

    var leagueInformation = [String: AnyObject]()
    var leagueTableAddress: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        initLeagueTableAddress()
        findLeagueTableData()
    }
    
    private func findLeagueTableData(){
        
        let apiInstance = RestAPIManager.sharedInstance
        apiInstance.setLeagueTableAddress(address: leagueTableAddress!)
        apiInstance.getLeaguesTableInfo{ responseArray  in
            //for i in 0..<respnseArray.count{
                //if let info: [String: AnyObject] = respnseArray[i] as? [String: AnyObject] {
                    //self.leagueInfo.append(info)
                    //self.leagues.append(info[ConstantUrl.FootballResponseKey.Caption] as! String)
                    //print(info)

            //}

                //print(responseArray.allKeys)
            //}
            
            if responseArray["standings"] == nil{
                print(responseArray["standing"])
                
            }else if responseArray["standing"] == nil{
                print(responseArray["standings"])
            }else{
                print("Ever seen a league table for that competition?")
            }

            
        }
    }
    
    private func initLeagueTableAddress(){
        var links: [String: AnyObject] = leagueInformation["_links"] as! [String : AnyObject]
        var leagueTable = links["leagueTable"] as! [String : AnyObject]
        leagueTableAddress = leagueTable["href"]! as? String
        //print(leagueTableAddress!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
