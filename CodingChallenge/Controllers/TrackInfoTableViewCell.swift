//
//  TrackInfoTableViewCell.swift
//  CodingChallenge
//
//  Created by Sukhpreet Deol on 2/9/18.
//  Copyright © 2018 Sukhpreet Deol. All rights reserved.
//

import UIKit

class TrackInfoTableViewCell: UITableViewCell {

    /// Outlets, instances, for the UIViews avaiable in the prototype cell.
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackArtistLabel: UILabel!
    @IBOutlet weak var trackAlbumLabel: UILabel!
    @IBOutlet weak var trackAlbumArtImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
