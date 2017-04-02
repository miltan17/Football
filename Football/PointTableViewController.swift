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
    
    var tournamentsPointTableInformation = [String: AnyObject]()
    
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
                let info:[[String: AnyObject]] = (responseArray["standing"] as? [[String: AnyObject]])!
                print(info)
            }else if responseArray["standing"] == nil{
                print(responseArray)
                self.tournamentsPointTableInformation = responseArray
                /*
                print("Response:\(self.pointTableInformation["standings"]!.allKeys!.count)")
                //print(responseArray["standings"]!)
                var keyArr = responseArray["standings"]!.allKeys!
                print(keyArr)
                var groupA :[String: AnyObject] = responseArray["standings"]! as! [String : AnyObject]
                let key: String = keyArr[1] as! String
                
                print(groupA[key]!.count)*/
                self.groupData = self.tournamentsPointTableInformation["standings"]! as! [String : AnyObject]
                self.keys = self.tournamentsPointTableInformation["standings"]!.allKeys as! [String]
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

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return findTotalSection()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
 
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.text = "Group: \(findKeyForSection(section))"
            headerView.textLabel?.textColor = UIColor ( red: 0.0902, green: 0.2745, blue: 0.2745, alpha: 1.0 )
            headerView.contentView.backgroundColor = UIColor.green
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowNumber = findTotalRowAtSection(section)
        return rowNumber+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = pointTable.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath)
            return cell
        }
        let cell = pointTable.dequeueReusableCell(withIdentifier: "pointCell", for: indexPath) as! PointTableCell
        let teamDataForEachRow: [String: AnyObject] = findCellDataForSection(indexPath.section, withRow: indexPath.row-1)

        cell.rank.text = String(describing: teamDataForEachRow["rank"]!)
        cell.team.text = teamDataForEachRow["team"] as? String
        cell.playedGame.text = String(describing: teamDataForEachRow["playedGames"]!)
        cell.goalDifference.text = String(describing: teamDataForEachRow["goalDifference"]!)
        cell.goalAgainst.text = String(describing: teamDataForEachRow["goalsAgainst"]!)
        cell.goals.text = String(describing: teamDataForEachRow["goals"]!)
        cell.points.text = String(describing: teamDataForEachRow["points"]!)
        
        return cell
    }
    
    private func findTotalSection() -> Int{
        if tournamentsPointTableInformation.count == 0 {
            return tournamentsPointTableInformation.count
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
        return keys[section] 
    }
    
    private func findCellDataForSection(_ section: Int, withRow: Int)-> [String: AnyObject]{
        let key: String = findKeyForSection(section)
        let group:[[String: AnyObject]] = (groupData[key] as? [[String: AnyObject]])!
        return group[withRow] as [String: AnyObject]
    }
}
