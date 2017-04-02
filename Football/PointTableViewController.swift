//
//  PointTableViewController.swift
//  Football
//
//  Created by MbProRetina on 3/22/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class PointTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pointTable: UITableView!
    
    var leagueInformation = [String: AnyObject]()
    
    var leagueTableAddress: String?
    
    var pointTableInformation = [String: AnyObject]()
    
    var groupData = [String: AnyObject]()
    
    var eachGroup = [String: AnyObject]()
    
    var keys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLeagueTableAddress()
        findLeagueTableData()
    }
    
    private func findLeagueTableData(){
        let apiInstance = RestAPIManager.sharedInstance
        apiInstance.setLeagueTableAddress(address: leagueTableAddress!)
        apiInstance.getLeaguesTableInfo{ responseArray  in
            
            if responseArray["standings"] == nil{
                
            }else if responseArray["standing"] == nil{
                self.pointTableInformation = responseArray
                /*
                print("Response:\(self.pointTableInformation["standings"]!.allKeys!.count)")
                //print(responseArray["standings"]!)
                var keyArr = responseArray["standings"]!.allKeys!
                print(keyArr)
                var groupA :[String: AnyObject] = responseArray["standings"]! as! [String : AnyObject]
                let key: String = keyArr[1] as! String
                
                print(groupA[key]!.count)*/
                self.groupData = self.pointTableInformation["standings"]! as! [String : AnyObject]
                self.keys = self.pointTableInformation["standings"]!.allKeys as! [String]
                //arr[section] as! String
                for i in 0..<self.keys.count{
                    self.eachGroup[self.keys[i]] = self.groupData[self.keys[i]]
                }
                //print("each Group: \(self.groupData["B"])")
            }else{
                print("Ever seen a league table for that competition?")
            }
            //print(self.pointTableInformation)
            //print(self.pointTableInformation.sorted(by: { $0.0 < $1.0 }))
            self.refresh()
        }
    }
    
    private func refresh(){
        DispatchQueue.main.sync {
            self.pointTable.reloadData()
        }
    }
    
    private func initLeagueTableAddress(){
        var links: [String: AnyObject] = leagueInformation["_links"] as! [String : AnyObject]
        var leagueTable = links["leagueTable"] as! [String : AnyObject]
        leagueTableAddress = leagueTable["href"]! as? String
    }

    
    var items = ["one","two","three","four"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return findTotalSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowNumber = findTotalRowAtSection(section)
        //print("Row Found:\(rowNumber)")
        return rowNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pointTable.dequeueReusableCell(withIdentifier: "pointCell", for: indexPath)
        let rowTeamData: [String: AnyObject] = findCellDataForSection(indexPath.section, withRow: indexPath.row)
        cell.textLabel?.text = rowTeamData["team"] as! String
        return cell
    }
    
    private func findTotalSection() -> Int{
        if pointTableInformation.count == 0 {
            return pointTableInformation.count
        }
        return keys.count
    }
    
    private func findTotalRowAtSection(_ section: Int) -> Int{
        
        //var groupData :[String: AnyObject] = getPointTableInformaiton()
        let key: String = findKeyForSection(section)
        let rowCounted = groupData[key]!.count
        return rowCounted!
    }
    
        
    private func findKeyForSection(_ section: Int) -> String{
        return keys[section] as! String
    }
    
    private func findCellDataForSection(_ section: Int, withRow: Int)-> [String: AnyObject]{
        let key: String = findKeyForSection(section)
        let group:[[String: AnyObject]] = (groupData[key] as? [[String: AnyObject]])!
        return group[withRow] as [String: AnyObject]
    }
}
