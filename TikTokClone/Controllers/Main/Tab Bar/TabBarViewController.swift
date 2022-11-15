//
//  TabBarViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpControllers()
        
        view.backgroundColor = .systemBackground
        
    }

    // Setting up tab bar controllers
    private func setUpControllers() {
        
        let home = UINavigationController(rootViewController: HomeViewController())
        let explore = UINavigationController(rootViewController: ExploreViewController())
        let camera = UINavigationController(rootViewController: CameraViewController())
        let notifications = UINavigationController(rootViewController: NotificationsViewController())
        let profile = UINavigationController(rootViewController: ProfileViewController(user: UserModel(username: "markoant123", profilePicURL: nil, identifier: "123")))
        
        home.navigationBar.setBackgroundImage(UIImage(), for: .default)
        home.navigationBar.shadowImage = UIImage()
        home.navigationBar.backgroundColor = .clear
        
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        explore.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "star"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "camera"), tag: 3)
        notifications.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(systemName: "bell"), tag: 4)
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 5)
        
        setViewControllers([home, explore, camera, notifications, profile], animated: false)
    }

}
