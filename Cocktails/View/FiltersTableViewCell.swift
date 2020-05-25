//
//  FiltersTableViewCell.swift
//  Cocktails
//
//  Created by Aleksei Chupriienko on 23.05.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import UIKit

class FiltersTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var label: UILabel!
    
    //MARK: - Lifecycle
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }

}
