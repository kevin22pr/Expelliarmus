//
//  SettingsViewController.swift
//  Tasker
//
//  Created by Kevin Flores Alvarez on 10/27/19.
//  Copyright © 2019 kevin flores. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    }
    
    func setUpNavigationBar(){
        self.navigationItem.title = "Settings"
    }

}
