//
//  AlbumCell.swift
//  someAPIMadness
//
//  Created by Nizelan on 24.07.2020.
//  Copyright © 2020 Nizelan. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    
    @IBOutlet weak var imageViewOutlet: UIView!
    @IBOutlet weak var imageNameOutlet: UILabel!
    
    @IBOutlet weak var upsOutlet: UILabel!
    @IBOutlet weak var downsOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
