//
//  TabViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

final class TabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .appMainColor
        tabBar.unselectedItemTintColor = .appGray
        tabBar.scrollEdgeAppearance = UITabBarAppearance()
        
        let main = UINavigationController(rootViewController: MainViewController())
        main.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let msv = UINavigationController(rootViewController: MyShoppingListView())
        msv.tabBarItem = UITabBarItem(title: "장바구니", image: UIImage(systemName: "cart.fill"), tag: 1)
        
        let setting = UINavigationController(rootViewController: SettingViewController())
        setting.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 2)
        
        setViewControllers([main, msv, setting], animated: true)
    }
}
