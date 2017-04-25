

import UIKit

class LeaguesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var leaguesTable: UITableView!
    var leagueInfo = [[String: AnyObject]]()
    var leagues = [String](){
        didSet{
            leaguesTable.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        self.title = "Leagues"
        initLeaguesData()
    }
    
    func initLeaguesData(){
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
            self.leaguesTable.reloadData()
            self.animateTable()
        }
    }
    
    private func animateTable(){
        let cells = leaguesTable.visibleCells
        let height  = leaguesTable.bounds.size.height
        
        for cell in cells{
            cell.transform = CGAffineTransform(translationX: 0 , y: height)
        }
        
        var delayCount = 0
        for cell in cells{
            UIView.animate(withDuration: 1.75, delay: Double(delayCount) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            
            delayCount += 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = leaguesTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = leagues[indexPath.row]
        return cell
        
    }


}
