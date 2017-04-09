//
//  LeaguesTableViewController.swift
//  Football
//
//  Created by MbProRetina on 3/21/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class LeaguesTableViewController: UITableViewController {
    
    var leagueInfo = [[String: AnyObject]]()
    var leagues = [String](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        findMenuItems()
    }
    
    private func findMenuItems(){
        RestAPIManager.sharedInstance.getLeaguesInfo{ respnseArray  in
            for i in 0..<respnseArray.count{
                if let info: [String: AnyObject] = respnseArray[i] as? [String: AnyObject] {
                    self.leagueInfo.append(info)
                    self.leagues.append(info[ConstantUrl.FootballResponseKey.Caption] as! String)
                }
            }
            self.refresh()
        }
    }
    
    private func refresh(){
        DispatchQueue.main.sync {
            self.tableView.reloadData()
            self.animateTable()
        }
    }
    
    private func animateTable(){
        let cells = tableView.visibleCells
        let width  = tableView.bounds.size.width
        
        for cell in cells{
            cell.transform = CGAffineTransform(translationX: width , y: 0)
        }
        
        var delayCount = 0
        for cell in cells{
            UIView.animate(withDuration: 1.75, delay: Double(delayCount) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            
            delayCount += 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = leagues[indexPath.row]

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PointTable"){
            var indexPath = self.tableView.indexPathForSelectedRow
            let destinationVC: PointTableViewController = segue.destination as! PointTableViewController
            destinationVC.leagueInformation = leagueInfo[(indexPath?.row)!]
            destinationVC.title = self.tableView.cellForRow(at: indexPath!)?.textLabel?.text
        }
        
    }

}
