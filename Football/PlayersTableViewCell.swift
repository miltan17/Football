
import UIKit

class PlayersTableViewCell: UITableViewCell {

    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var playerNationality: UILabel!
    @IBOutlet weak var playerJerseyNumber: UILabel!
    @IBOutlet weak var playerDateOfBirth: UILabel!
    @IBOutlet weak var playerContractDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        playerName.text = ""
        playerPosition.text = ""
        playerNationality.text = ""
        playerJerseyNumber.text = ""
        playerDateOfBirth.text = ""
        playerContractDate.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
