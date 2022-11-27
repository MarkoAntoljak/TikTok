//
//  EditProfileViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/26/22.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Profile"
        
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    
    @objc
    private func didTapClose() {
        
        self.dismiss(animated: true)
    }


}
