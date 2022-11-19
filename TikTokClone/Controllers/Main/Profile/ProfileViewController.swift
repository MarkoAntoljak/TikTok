//
//  ProfileViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: Attributes
    
    var user: UserModel
    
    // MARK: UI Elements
    private lazy var btnLogOut: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    // MARK: Init
    
    init(user: UserModel) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = user.username.lowercased()
        
        view.addSubview(btnLogOut)
        
        print(user.username.lowercased())
        
        addActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
        
    }
    
    // MARK: Functions
    
    private func setFrames() {
        
        btnLogOut.sizeToFit()
        btnLogOut.frame = CGRect(x: 0, y: 0, width: btnLogOut.width + 20, height: btnLogOut.height + 20)
        btnLogOut.center.x = view.center.x
        btnLogOut.center.y = view.center.y
        
    }
    
    private func addActions() {
        
        btnLogOut.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
        
    }
    
    // MARK: Actions
    
    @objc
    private func didTapLogOut() {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                self.logOut()
            }))
            
            self.present(alert, animated: true)
        }
        
    }
    
    
    // MARK: Functions
    
    private func logOut() {
        
        AuthManager.shared.signOut { [weak self] success in
            
            if success {
                
                DispatchQueue.main.async {
                    // going to sign in screen
                    let vc = SignInViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: true)
                    SceneDelegate.shared.window?.rootViewController = navVC
                }
                
            } else {
                print("cannot sign out")
            }
        }
        
        
    }
    
    
    
    
    
    
    
}
