//
//  FixtureViewController.swift
//  Football
//
//  Created by MbProRetina on 4/12/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class FixtureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var fixtureTableView: UITableView!
    
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
            self.refresh()
        }
    }
    
    
    private func findFixtureSectionName(){
        for key in fixtureData.keys{
            self.fixtureSectionArray.append(key)
        }
        fixtureSectionArray.sort()
    }
    
    
    private func refresh(){
        DispatchQueue.main.sync {
            self.fixtureTableView.reloadData()
            self.animateTable()
        }
    }
    
    private func animateTable(){
        let cells = fixtureTableView.visibleCells
        let height = fixtureTableView.bounds.size.height
        
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
    
    
    /// table view control
    func numberOfSections(in tableView: UITableView) -> Int {
        return fixtureSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Matchday: " + String(fixtureSectionArray[section])
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.textColor = UIColor ( red: 0.0902, green: 0.2745, blue: 0.2745, alpha: 1.0 )
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return findNumberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fixtureTableView.dequeueReusableCell(withIdentifier: "fixtureCell", for: indexPath) as! fixtureTableCell
        
        let fixtureOfEachRow = findEachGameScheduleWithSection(indexPath.section, row: indexPath.row)
        cell.homeTeamName.text = fixtureOfEachRow["homeTeamName"] as? String
        cell.awayTeamName.text = fixtureOfEachRow["awayTeamName"] as? String
        
        if fixtureOfEachRow["result"]?["goalsHomeTeam"]! is NSNull || fixtureOfEachRow["result"]?["goalsAwayTeam"]! is NSNull{
            print("Null Found")
            cell.homeTeamGoal.text = "N"
            cell.awayTeamGoal.text = "N"
        }else{
            let homeGoal = fixtureOfEachRow["result"]?["goalsHomeTeam"]!
            let awayGoal = fixtureOfEachRow["result"]?["goalsAwayTeam"]!
            cell.homeTeamGoal.text = String(describing: homeGoal!)
            cell.awayTeamGoal.text = String(describing: awayGoal!)
            
            if homeGoal as! Int > awayGoal as! Int{
                cell.homeTeamName.textColor = UIColor.green
                cell.awayTeamName.textColor = UIColor.red
                cell.homeTeamGoal.textColor = UIColor.green
                cell.awayTeamGoal.textColor = UIColor.red
            }else if (homeGoal as! Int) < (awayGoal as! Int){
                cell.homeTeamName.textColor = UIColor.red
                cell.awayTeamName.textColor = UIColor.green
                cell.homeTeamGoal.textColor = UIColor.red
                cell.awayTeamGoal.textColor = UIColor.green
            }
        }
        let (date,time) = findDateAndTime(fixtureOfEachRow["date"]! as! String)
        cell.matchDate.text = date
        cell.matchTime.text = time
        return cell
    }
    
    private func findNumberOfRowsInSection(_ section: Int) -> Int{
        
        return fixtureData[fixtureSectionArray[section]]!.count
    }
    
    private func findEachGameScheduleWithSection(_ section: Int, row: Int) -> [String: AnyObject]{
        let fixtureOfEachRow: [String: AnyObject] = fixtureData[fixtureSectionArray[section]]![row] as! [String : AnyObject]
        
        return fixtureOfEachRow
    }
    
    private func findDateAndTime(_ dateAndTime: String) -> (String, String){
        var fullDateArr = dateAndTime.components(separatedBy: "T")
        let date: String = fullDateArr[0]
        
        let fullTime: String = fullDateArr[1]
        
        var fullTimeArray = fullTime.components(separatedBy: "Z")
        let time: String = fullTimeArray[0]
        
        return (date, time)
    }
    
}
