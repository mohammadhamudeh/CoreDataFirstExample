//
//  carTableViewCell.swift
//  CoreDataSolve
//
//  Created by Mohammad Hamudeh on 3/16/20.
//  Copyright © 2020 Al-Quds University. All rights reserved.
//

import UIKit

class carTableViewCell: UITableViewCell {
    @IBOutlet weak var carBrand: UILabel!
    
    @IBOutlet weak var carPrice: UILabel!
    @IBOutlet weak var carModel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
