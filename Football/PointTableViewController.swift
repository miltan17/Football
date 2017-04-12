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
    
    var leaguePointTableInfo = [[String: AnyObject]]()
    
    var groupData = [String: AnyObject]()
    
    var eachGroup = [String: AnyObject]()
    
    var keys = [String]()
    
    var isSectionPresent: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLeagueTableAddress()
        findLeagueTableData()
        isSectionPresent = true
    }
    
    private func findLeagueTableData(){
        let apiInstance = RestAPIManager.sharedInstance
        apiInstance.setLeagueTableAddress(address: leagueTableAddress!)
        apiInstance.getLeaguesPointTableInfo{ responseJSON  in
            
            if responseJSON["standings"] == nil{
                if responseJSON["standing"] == nil{
                    self.showAlert(responseJSON["error"] as! String)
                }else{
                    self.isSectionPresent = false
                    self.leaguePointTableInfo = (responseJSON["standing"] as? [[String: AnyObject]])!
                }
            }else if responseJSON["standing"] == nil{
                self.isSectionPresent = true
                self.tournamentsPointTableInformation = responseJSON
                self.groupData = self.tournamentsPointTableInformation["standings"]! as! [String : AnyObject]
                self.keys = self.tournamentsPointTableInformation["standings"]!.allKeys as! [String]
                for i in 0..<self.keys.count{
                    self.eachGroup[self.keys[i]] = self.groupData[self.keys[i]]
                }
            }else{
                print("Ever seen a league table for that competition?")
            }
            self.refresh()
        }
    }
    
    private func showAlert(_ message: String){
        let alertController = UIAlertController(title: "No Such League", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func refresh(){
        DispatchQueue.main.sync {
            self.pointTable.reloadData()
            self.animateTable()
        }
    }
    
    private func animateTable(){
        let cells = pointTable.visibleCells
        let height = pointTable.bounds.size.height
        
        for cell in cells{
            cell.transform = CGAffineTransform(translationX: 0, y: height)
        }
        
        var delayCount = 0
        for cell in cells{
            UIView.animate(withDuration: 1.75, delay: Double(delayCount) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            
            delayCount += 1
        }
    }
    
    
    private func initLeagueTableAddress(){
        var links: [String: AnyObject] = leagueInformation["_links"] as! [String : AnyObject]
        var leagueTable = links["leagueTable"] as! [String : AnyObject]
        leagueTableAddress = leagueTable["href"]! as? String
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSectionPresent!{
            return findTotalSection()
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSectionPresent! {
            return " "
        }else{
            return nil
        }
    }
 
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if isSectionPresent! {
            if let headerView = view as? UITableViewHeaderFooterView {
                headerView.textLabel?.textAlignment = .center
                headerView.textLabel?.text = "Group: \(findKeyForSection(section))"
                headerView.textLabel?.textColor = UIColor ( red: 0.0902, green: 0.2745, blue: 0.2745, alpha: 1.0 )
                headerView.contentView.backgroundColor = UIColor.green
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSectionPresent! {
            let rowNumber = findTotalRowAtSection(section)
            return rowNumber+1
        }
        return leaguePointTableInfo.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSectionPresent! {
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
        }else{
            if indexPath.row == 0{
                let cell = pointTable.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as! FirstTableCell
                //cell.playedGameLabel.text = "GP"
                cell.winsLabel.text = "W"
                cell.lossesLabel.text = "L"
                return cell
            }
            let cell = pointTable.dequeueReusableCell(withIdentifier: "pointCell", for: indexPath) as! PointTableCell
            let rowInfo: [String: AnyObject] = leaguePointTableInfo[indexPath.row - 1]
            
            cell.rank.text = String(describing: rowInfo["position"]!)
            cell.team.text = rowInfo["teamName"] as? String
            cell.playedGame.text = String(describing: rowInfo["playedGames"]!)
            cell.goalDifference.text = String(describing: rowInfo["wins"]!)
            cell.goalAgainst.text = String(describing: rowInfo["losses"]!)
            cell.goals.text = String(describing: rowInfo["goals"]!)
            cell.points.text = String(describing: rowInfo["points"]!)
            
            return cell
        }
    }
    
    private func findTotalSection() -> Int{
        if tournamentsPointTableInformation.count == 0 {
            return tournamentsPointTableInformation.count
        }
        return keys.count
    }
    
    private func findTotalRowAtSection(_ section: Int) -> Int{
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
