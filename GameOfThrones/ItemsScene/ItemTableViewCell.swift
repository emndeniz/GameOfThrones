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

    @IBOutlet private(set) weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    func loadData(name:String){
        nameLabel.text = name
    }
    
    // Only Unit tests will call this init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabel = testLabel
    }

    private var testLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
}


class ItemWithImageTableViewCell: UITableViewCell, ItemsTableCellProtool {

    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var headerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    func loadData(name:String, image:UIImage){
        nameLabel.text = name
        headerImage.image = image
    }
    
    // Only Unit tests will call this init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabel = testLabel
        headerImage = testImageView
    }
    
    
    private var testLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var testImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
}

