//
//  DetailsViewController.swift
//  GameOfThrones
//
//  Created by Emin on 12.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class DetailsViewController: UIViewController {

    // MARK: - Public properties -

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageHeightAnchor: NSLayoutConstraint!
    var presenter: DetailsPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Details"
        presenter.viewDidLoad()
    }

}

// MARK: - Extensions -

extension DetailsViewController: DetailsViewInterface {
    func updateUI(text: String, image: UIImage?) {
        textView.text = text
        if let image = image {
            imageView.image = image
        }else {
            imageHeightAnchor.constant = 0
        }
    }
    
}
