
import UIKit

class TeamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var teamsTable: UITableView!
    
    var teamsURL = String()
    
    var teams = [[String: String]](){
        didSet{
            teamsTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTeam()
    }
    
    func initTeam(){
        let apiInstance = RestAPIManager.sharedInstance
        apiInstance.setLeagueTableAddress(address: teamsURL)
        apiInstance.getLeaguesPointTableInfo{ responseJSON  in
            
            guard let teamsInfo:[[String: AnyObject]] = responseJSON["teams"] as! [[String : AnyObject]]? else{
                return
            }
            
            for team in teamsInfo{
                var eachTeamInfo = [String: String]()
                if let name = team["name"] as? String{
                    eachTeamInfo["name"] = name
                }
                if let code = team["code"] as? String{
                    eachTeamInfo["code"] = code
                }
                if let teamLink = team["_links"] as? [String: AnyObject]{
                    if let teamsPlayers = teamLink["players"] as? [String: AnyObject]{
                        if let playersLink = teamsPlayers["href"] as? String {
                            eachTeamInfo["Playerslink"] = playersLink
                        }
                    }
                }
                self.teams.append(eachTeamInfo)
            }
            self.refresh()
        
        }
    }
    
    func refresh(){
        DispatchQueue.main.sync {
            self.teamsTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teamsTable.dequeueReusableCell(withIdentifier: "teamsCell", for: indexPath)
        cell.textLabel?.text = teams[indexPath.row]["name"]
        cell.detailTextLabel?.text = teams[indexPath.row]["code"]
        return cell
    }
}
