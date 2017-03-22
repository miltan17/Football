

import UIKit

class MenuTableViewController: UITableViewController {

    var menuArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuArray = ["Leagues","Teams"]
        
        
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
}
