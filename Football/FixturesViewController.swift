//
//  FixturesViewController.swift
//  Football
//
//  Created by MbProRetina on 4/3/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit
import Foundation

class FixturesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var fixtureTable: UITableView!
    
    var fixture = [[String: AnyObject]](){
        didSet{
            print("Data Found")
        }
    }
    
    var fixtureData = [Date: [AnyObject]]()
    
    var fixtureSectionArray = [Date]()
    
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
                        let date = self.findDateOnly(value as! String)
                        if self.fixtureData.keys.contains(date){
                            self.fixtureData[date]?.append(fixture as AnyObject)
                        }else{
                            self.fixtureData[date] = [fixture as AnyObject]
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
    
    private func findDateOnly(_ dateANDtime: String) -> Date{
        var fullDateArr = dateANDtime.components(separatedBy: "T")
        let date: String = fullDateArr[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter.date(from: date)!
    }
    
    private func findTimeOnly(_ dateANDtime: String) -> String{
        var fullDateArr = dateANDtime.components(separatedBy: "T")
        let fullTime: String = fullDateArr[1]
        
        var fullTimeArray = fullTime.components(separatedBy: "Z")
        let time: String = fullTimeArray[0]
        return time
    }
    
    
    private func findStringDate(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    private func refresh(){
        DispatchQueue.main.sync {
            self.fixtureTable.reloadData()
            self.animateTable()
        }
    }
    
    private func animateTable(){
        let cells = fixtureTable.visibleCells
        let height = fixtureTable.bounds.size.height
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fixtureSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return findHeaderForSection(section)
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
        let cell = fixtureTable.dequeueReusableCell(withIdentifier: "allfixtureCell", for: indexPath) as! FixtureCell
        let fixtureOfEachRow = findEachGameScheduleWithSection(indexPath.section, row: indexPath.row)
        if fixtureOfEachRow["goalsHomeTeam"] != nil{
            cell.homeTeamGoal.text = (fixtureOfEachRow["goalsHomeTeam"]! as! String)
        }else if fixtureOfEachRow["goalsAwayTeam"] != nil{
            cell.awayTeamGoal.text = (fixtureOfEachRow["goalsAwayTeam"]! as! String)
        }
        cell.homeTeamName.text = (fixtureOfEachRow["homeTeamName"]! as! String)
        cell.awayTeamName.text = (fixtureOfEachRow["awayTeamName"]! as! String)
        cell.matchTime.text = findTimeOnly(fixtureOfEachRow["date"]! as! String)
        
        return cell
    }
    
    private func findHeaderForSection(_ section: Int) -> String{
        
        return findStringDate(fixtureSectionArray[section])
    }
    
    private func findNumberOfRowsInSection(_ section: Int) -> Int{
        
        return fixtureData[fixtureSectionArray[section]]!.count
    }
    
    private func findEachGameScheduleWithSection(_ section: Int, row: Int) -> [String: AnyObject]{
        let fixtureOfEachRow: [String: AnyObject] = fixtureData[fixtureSectionArray[section]]![row] as! [String : AnyObject]
        
        return fixtureOfEachRow
    }
    
}
