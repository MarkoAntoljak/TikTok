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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator = false
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collection
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
        navigationController?.tabBarItem.title = "Profile"
        
        view.addSubview(btnLogOut)
        
        print(user.username.lowercased())
        
        addActions()
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
        
        collectionView.frame = view.bounds
     
        
    }
    
    // MARK: Functions
    
    private func setFrames() {
        
        
        btnLogOut.frame = CGRect(x: 0, y: 0, width: 280, height: 50)
        btnLogOut.center.x = view.center.x
        btnLogOut.center.y = view.bottom - 150
        
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

// MARK: Delegates

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (view.width - 12) / 3
        return CGSize(width: width, height: width * 1.8)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
}

