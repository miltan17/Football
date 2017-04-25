

import UIKit

class PlayersViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

    var playersURL = String()
    
    var players = [[String: String]](){
        didSet{
            self.playersTable.reloadData()
        }
    }
    
    @IBOutlet weak var playersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPlayers()
    }

    func initPlayers(){
        let apiInstance = RestAPIManager.sharedInstance
        apiInstance.setLeagueTableAddress(address: playersURL)
        apiInstance.getLeaguesPointTableInfo{ responseJSON  in
            
            guard let playersInfo:[[String: AnyObject]] = responseJSON["players"] as! [[String : AnyObject]]? else{
                return
            }
            
            for playerInfo in playersInfo{
                self.players.append(self.getEachPlayerInfo(playerInfo))
                print(self.getEachPlayerInfo(playerInfo))
            }
            self.refresh()
        }
    }
    
    func getEachPlayerInfo(_ playerInfo: [String: AnyObject]) -> [String: String]{
        var eachPlayerInfo = [String: String]()
        
        if let name = playerInfo["name"] as? String{
            eachPlayerInfo["name"] = name
        }
        if let position = playerInfo["position"] as? String{
            eachPlayerInfo["position"] = position
        }
        if let dateOfBirth = playerInfo["dateOfBirth"] as? String{
            eachPlayerInfo["dateOfBirth"] = dateOfBirth
        }
        if let jerseyNumber = playerInfo["jerseyNumber"] as? String{
            eachPlayerInfo["jerseyNumber"] = jerseyNumber
        }
        if let nationality = playerInfo["nationality"] as? String{
            eachPlayerInfo["nationality"] = nationality
        }
        if let contractUntil = playerInfo["contractUntil"] as? String{
            eachPlayerInfo["contractUntil"] = contractUntil
        }
        
        return eachPlayerInfo
    }
    
    func refresh(){
        DispatchQueue.main.sync {
            self.playersTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersTable.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayersTableViewCell
        
        cell.playerName.text = players[indexPath.row]["name"]
        cell.playerPosition.text = players[indexPath.row]["position"]
        cell.playerNationality.text = players[indexPath.row]["nationality"]
        cell.playerJerseyNumber.text = players[indexPath.row]["jerseyNumber"]
        cell.playerDateOfBirth.text =  players[indexPath.row]["dateOfBirth"]
        cell.playerContractDate.text = players[indexPath.row]["contractUntil"]
        
        return cell
    }
}
