//
//  TabViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

class TabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .appMainColor
        tabBar.unselectedItemTintColor = .appGray
        tabBar.scrollEdgeAppearance = UITabBarAppearance()
        
        let main = UINavigationController(rootViewController: MainViewController())
        main.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let setting = UINavigationController(rootViewController: SettingViewController())
        setting.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 1)
        
        setViewControllers([main, setting], animated: true)
    }
}
