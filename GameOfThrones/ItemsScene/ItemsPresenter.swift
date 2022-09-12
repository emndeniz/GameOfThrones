//
//  ItemsPresenter.swift
//  GameOfThrones
//
//  Created by Emin on 12.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class ItemsPresenter {

    // MARK: - Private properties -

    private unowned let view: ItemsViewInterface
    private let interactor: ItemsInteractorInterface
    private let wireframe: ItemsWireframeInterface
    
    private var items: [ItemsModelProtocol]

    // MARK: - Lifecycle -

    init(
        view: ItemsViewInterface,
        interactor: ItemsInteractorInterface,
        wireframe: ItemsWireframeInterface,
        items: [ItemsModelProtocol]
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.items = items
    }
}

// MARK: - Extensions -

extension ItemsPresenter: ItemsPresenterInterface {
    
    var numberOfRows: Int {
        return items.count
    }
    
    func categoryAtIndex(index: Int,tableView:UITableView) -> ItemsTableCellProtool {
        let data = items[index]
        
        let name = data.name ?? "Name not provided"
        if let imageName: String = (data as? HousesResponseElement)?.region,
            let image = UIImage(named: imageName){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemWithImageTableViewCell") as! ItemWithImageTableViewCell
            cell.loadData(name: name, image: image)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as! ItemTableViewCell
            cell.loadData(name: name)
            return cell
        }
    }
    
    func didSelectRow(index: Int) {
        let selectedRow = items[index]
        print(selectedRow)
    }
    
}


