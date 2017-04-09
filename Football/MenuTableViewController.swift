

import UIKit

class MenuTableViewController: UITableViewController {

    var menuArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuArray = ["Leagues","Fixtures","Teams"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuArray[indexPath.row
            ], for: indexPath)

        cell.textLabel?.text = menuArray[indexPath.row]
        return cell
    }
    
    private func animateTable(){
        let cells = tableView.visibleCells
        let height = tableView.bounds.size.height
        
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
}
