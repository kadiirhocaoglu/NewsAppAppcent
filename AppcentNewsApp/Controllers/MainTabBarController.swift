//
//  MainTabBarController.swift
//  AppcentNewsApp
//
//  Created by Kadir Hocaoğlu on 13.05.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.setupTabs()
        self.setupTabBar()
    }
    
    private func setupTabs() {
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: FavoriteNewsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "heart.square")
        
        vc1.title = "News"
        vc2.title = "Favorites"

        setViewControllers([vc1, vc2], animated: true)
    }
    private func setupTabBar(){
        UITabBar.appearance().barStyle = .default
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = .label
    }
}
