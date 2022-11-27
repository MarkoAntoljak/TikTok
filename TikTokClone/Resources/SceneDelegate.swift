//
//  SceneDelegate.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    static let shared = SceneDelegate()
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // initial window setup
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // inital screen configuration based on if the user is already signed in
        if AuthManager.shared.isSignedIn {
            
            window.rootViewController = TabBarViewController()
            
        } else {
            
            let navController = UINavigationController(rootViewController: SignInViewController())
            
            window.rootViewController = navController
        
        }
        
        window.makeKeyAndVisible()
        
    }

}

