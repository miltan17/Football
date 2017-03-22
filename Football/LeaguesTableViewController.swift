//
//  LeaguesTableViewController.swift
//  Football
//
//  Created by MbProRetina on 3/21/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit

class LeaguesTableViewController: UITableViewController {
    @IBOutlet weak var menuItems: UIBarButtonItem!
    
    var leagues = [String](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuItems.target = self.revealViewController()
        menuItems.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //leagues = ["one","two"]
        
        findMenuArrayUsingApi()
        
    }
    
    private func findMenuArrayUsingApi(){
        
        let request = getRequest()
        
        startTaskWithRequest(request: request)
    }
    
    private func startTaskWithRequest(request: URLRequest){
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let parsedResult: [[String:AnyObject]]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:AnyObject]]
            } catch{
                print("Could not parse the data as JSON:")
                return
            }
            
            for i in 0..<parsedResult.count{
                guard let competitionsDictionary = parsedResult[i] as? [String: AnyObject]  else{
                    return
                }
                self.leagues.append(competitionsDictionary["league"] as! String)
                //print(competitionsDictionary["league"] as! String)
            }
            self.refresh()
            //print(self.leagues)
            
        }
        print(leagues)
        task.resume()
    }
    
    private func refresh(){
        DispatchQueue.main.sync {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Get Call
    
    private func getRequest() -> URLRequest {
        let urlString = ConstantUrl.FootballURL.competitionsUrl + getCurrentSeason()
        let url = NSURL(string: urlString)
        var request = URLRequest(url: url as! URL)
        request.addValue("cfb4022f9677439db603161f03e9bb0e ", forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = "GET"
        
        return request
    }
    
    private func getCurrentSeason() -> String{
        let date = Date()
        let calendar = Calendar.current
        let season = calendar.component(.year, from: date)
        
        return String(describing: season - 1)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return leagues.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = leagues[indexPath.row]

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
