//
//  DetailsInterfaces.swift
//  GameOfThrones
//
//  Created by Emin on 12.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

protocol DetailsWireframeInterface: WireframeInterface {
}

protocol DetailsViewInterface: ViewInterface {
    func updateUI(text:String, image:UIImage?)
}

protocol DetailsPresenterInterface: PresenterInterface {
    func viewDidLoad()
}

protocol DetailsInteractorInterface: InteractorInterface {
}