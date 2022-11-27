//
//  TabBarViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit
import SDWebImage

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
         
        // set current user profile image
        var profileURL: URL?
        if let profilePictureURL = UserDefaults.standard.url(forKey: "profile_picture_url") {
            
            profileURL = profilePictureURL
        }
        
        let profile = UINavigationController(rootViewController: ProfileViewController(user: UserModel(
            username: UserDefaults.standard.string(forKey: "username") ?? "noUser",
            profilePicURL: profileURL,
            identifier: UserDefaults.standard.string(forKey: "username") ?? "noUser")))
        
        
        // home init setup
        home.navigationBar.setBackgroundImage(UIImage(), for: .default)
        home.navigationBar.shadowImage = UIImage()
        home.navigationBar.backgroundColor = .clear
        home.tabBarController?.tabBar.backgroundColor = .systemBackground
        
        // explore init setup
        explore.tabBarItem.title = "Activity"
        explore.tabBarController?.tabBar.backgroundColor = .systemBackground
        
        // camera init setup
        camera.tabBarController?.tabBar.isHidden = true
        camera.navigationBar.setBackgroundImage(UIImage(), for: .default)
        camera.navigationBar.shadowImage = UIImage()
        camera.navigationBar.backgroundColor = .clear
        
        // activity init setup
        notifications.tabBarController?.tabBar.backgroundColor = .systemBackground
        
        // profile init setup
        profile.navigationBar.tintColor = .label
        profile.tabBarController?.tabBar.backgroundColor = .systemBackground
        
        // configure tab bar items
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        explore.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "star"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "camera"), tag: 3)
        notifications.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(systemName: "bell"), tag: 4)
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 5)
        
        setViewControllers([home, explore, camera, notifications, profile], animated: false)
    }

}
