//
//  HomeViewCell.swift
//  Cocktails
//
//  Created by Aleksei Chupriienko on 23.05.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    //MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
        pictureView.image = nil
    }

}
