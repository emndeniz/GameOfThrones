//
//  ItemTableViewCell.swift
//  GameOfThrones
//
//  Created by Emin on 12.09.2022.
//

import UIKit

protocol ItemsTableCellProtool {
    
}

class ItemTableViewCell: UITableViewCell, ItemsTableCellProtool{

    @IBOutlet private weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadData(name:String){
        nameLabel.text = name
    }
}


class ItemWithImageTableViewCell: UITableViewCell, ItemsTableCellProtool {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var headerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadData(name:String, image:UIImage){
        nameLabel.text = name
        headerImage.image = image
    }
}

