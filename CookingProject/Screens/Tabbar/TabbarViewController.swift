//
//  TabbarViewController.swift
//  CookingProject
//
//  Created by Macbook Air on 17.05.2023.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addTabbarItem()
        setTabbarItem()
    }
}

// MARK: - Helpers
private extension TabbarViewController {
    
    func addTabbarItem() {
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIcon"), tag: 0)
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settingsIcon"), tag: 2)
        viewControllers = [homeViewController, settingsViewController]
    }
    
    func setTabbarItem() {
        self.tabBar.tintColor = .black
    }
}
