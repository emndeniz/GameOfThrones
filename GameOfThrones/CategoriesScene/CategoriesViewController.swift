//
//  CategoriesViewController.swift
//  GameOfThrones
//
//  Created by Emin on 10.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class CategoriesViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: CategoriesPresenterInterface!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Categories"
        activityIndicator.hidesWhenStopped = true
    }

}

// MARK: - Extensions -

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell") as! CategoriesTableViewCell
        cell.loadData(data: presenter.categoryAtIndex(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityIndicator.startAnimating()
        presenter.didSelectRow(index: indexPath.row)
    }
    
    
}

extension CategoriesViewController: CategoriesViewInterface {
    func stopIndicator() {
        activityIndicator.stopAnimating()
    }
    
}
