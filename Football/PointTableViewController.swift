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
        print("Row Fount:\(rowNumber)")
        return rowNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pointTable.dequeueReusableCell(withIdentifier: "pointCell", for: indexPath)
        //let cellData:[String: AnyObject] =
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    private func findTotalSection() -> Int{
        if pointTableInformation.count == 0 {
            return pointTableInformation.count
        }
        return pointTableInformation["standings"]!.allKeys!.count
    }
    
    private func findTotalRowAtSection(_ section: Int) -> Int{
        var arr = pointTableInformation["standings"]!.allKeys!
        var groupData :[String: AnyObject] = pointTableInformation["standings"]! as! [String : AnyObject]
        let key: String = arr[section] as! String
        let rowCounted = groupData[key]!.count
        return rowCounted!
    }
}
