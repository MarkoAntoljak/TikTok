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
        
        print(user.username.lowercased())
    }
    
    
    

}
