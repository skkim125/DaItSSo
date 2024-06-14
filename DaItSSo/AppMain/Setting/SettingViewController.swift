//
//  SettingViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "SETTING"
    }
}
