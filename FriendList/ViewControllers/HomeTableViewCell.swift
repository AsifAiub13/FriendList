//
//  HomeTableViewCell.swift
//  FriendList
//
//  Created by Asif on 10/29/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImgView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendEmailLabel: UILabel!
    @IBOutlet weak var friendCountryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
