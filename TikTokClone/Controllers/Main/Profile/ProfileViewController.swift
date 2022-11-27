//
//  ProfileViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit
import ProgressHUD

/// profile view controller
class ProfileViewController: UIViewController {
    
    // MARK: Attributes
    
    private var user: UserModel
    
    private lazy var posts = [PostModel]()
    
    private lazy var following = [String]()
    
    private lazy var followers = [String]()
    
    private var isFollower: Bool = false
    
    private var isCurrentUser: Bool {
        
        if let username = UserDefaults.standard.string(forKey: "username") {
            
            return user.username.lowercased() == username.lowercased()
        }
        
        return false
    }
    
    enum PicturePickerType {
        case photoLibrary
        case camera
    }
    
    // MARK: UI Elements
 
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator = false
        collection.register(ProfileHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.register(ProfilePostCollectionViewCell.self, forCellWithReuseIdentifier: ProfilePostCollectionViewCell.identifier)
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
        title = user.username
        navigationController?.tabBarItem.title = "Profile"
        
        let btnLogOut = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(didTapLogOut))
        btnLogOut.tintColor = .systemRed
        btnLogOut.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)], for: .normal)
        navigationItem.rightBarButtonItem = btnLogOut
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchPosts()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    
    }
    
    // MARK: Functions
    
    private func fetchPosts() {
        
        DatabaseManager.shared.getPosts(user: user) { [weak self] postModels in
            
            DispatchQueue.main.async {
                
                self?.posts = postModels
                self?.collectionView.reloadData()
            }
        }
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
    
    /// logging out the user
    private func logOut() {
        
        AuthManager.shared.signOut { [weak self] success in
            
            if success {
                
                UserDefaults.standard.set(nil, forKey: "username")
                UserDefaults.standard.set(nil, forKey: "profile_picture_url")
            
                DispatchQueue.main.async {
                    // going to sign in screen
                    let vc = SignInViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: false)
                    SceneDelegate.shared.window?.rootViewController = navVC
                }
            
                
            } else {
                print("cannot sign out")
            }
        }
    }
}

// MARK: Delegates

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    // configuring cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let postModel = posts[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePostCollectionViewCell.identifier, for: indexPath) as? ProfilePostCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(model: postModel)
        
        return cell
    }
    
    // selecting item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // open post
        DispatchQueue.main.async {
            
            let model = self.posts[indexPath.row]
            let vc = PostViewController(model: model)
            vc.title = "Video"
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    // size of item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (view.width - 12) / 3
        return CGSize(width: width, height: width * 1.8)
        
    }
    
    // line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // adding header to collection view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath) as? ProfileHeaderCollectionReusableView else {
            
            return UICollectionReusableView()
        }
        
        header.delegate = self
        
        // concurrency for performance
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        group.enter()
        
        DatabaseManager.shared.getFollows(for: user, type: .followers) { [weak self] followers in
            
            defer {
                group.leave()
            }
            
            self?.followers = followers
        }
        
        DatabaseManager.shared.getFollows(for: user, type: .following) { [weak self] following in
            
            defer {
                group.leave()
            }
            
            self?.following = following
        }
        
        DatabaseManager.shared.isValidRelationship(for: user, type: .followers) { [weak self] isFollower in
            
            defer {
                group.leave()
            }
            
            self?.isFollower = isFollower
        }
        
        group.notify(queue: .main) {
            
            let viewModel = ProfileHeaderViewModel(
                profileImageURL: self.user.profilePicURL,
                isFollowing: self.isCurrentUser ? nil : self.isFollower,
                followersCount: self.followers.count,
                followingCount: self.following.count)
            
            header.configure(with: viewModel)
        }
        
        return header
        
    }
    
    
    // size of header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
}

// MARK: ProfileHeaderCollectionReusableViewDelegate

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    
    // did tap primary button
    func profileHeaderCollectionReusableViewDelegate(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButton viewModel: ProfileHeaderViewModel) {
        
        if isCurrentUser {

            // show edit profile, nothing to edit just a blank vc
                let vc = EditProfileViewController()
                let navVC = UINavigationController(rootViewController: vc)
                present(navVC, animated: true)
            
        } else {
            
            // show follow/unfollow button
            if self.isFollower {
                // unfollow
                DatabaseManager.shared.updateRelationship(for: user, follow: false) { [weak self] success in
                    
                    DispatchQueue.main.async {
                        
                        if success {
                            print("false")
                            self?.isFollower = false
                            self?.collectionView.reloadData()
                        }
                    }
                }
                
            } else {
                // follow
                DatabaseManager.shared.updateRelationship(for: user, follow: true) { [weak self] success in
                    
                    DispatchQueue.main.async {
                        
                        if success {
                            
                            print("true")
                            
                            self?.isFollower = true
                            self?.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        
        
    }
    
    // did tap followers button
    func profileHeaderCollectionReusableViewDelegate(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButton viewModel: ProfileHeaderViewModel) {
        
        DispatchQueue.main.async {
            
            let vc = UserListViewController(user: self.user, type: .followers)
            vc.users = self.followers
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // did tap following button
    func profileHeaderCollectionReusableViewDelegate(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButton viewModel: ProfileHeaderViewModel) {
        
        DispatchQueue.main.async {
            
            let vc = UserListViewController(user: self.user, type: .following)
            vc.users = self.following
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // did tap profile image
    func profileHeaderCollectionReusableViewDelegate(_ header: ProfileHeaderCollectionReusableView, didTapProfileImage viewModel: ProfileHeaderViewModel) {
        
        guard isCurrentUser else {
            return
        }
        
        // show actions to change profile image
        let actions = UIAlertController(title: "Change Profile Picture", message: "Please select a method.", preferredStyle: .actionSheet)
        
        // go to photo library
        actions.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            
            DispatchQueue.main.async {
                self.presentProfileImagePicker(type: .photoLibrary)
            }
        }))
        
        // go to camera
        actions.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            DispatchQueue.main.async {
                self.presentProfileImagePicker(type: .camera)
            }
        }))
        
        // cancel
        actions.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(actions, animated: true)
        
        
    }
    
    private func presentProfileImagePicker(type: PicturePickerType) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        // upload selected image
        ProgressHUD.show("Uploading")
        
        StorageManager.shared.uploadProfilePicture(image: image) { [weak self] result in
            
            // reference counting handling
            guard let strongSelf = self else {return}
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let url):
                    
                    UserDefaults.standard.set(url, forKey: "profile_picture_url")
                    
                    strongSelf.user = UserModel(username: strongSelf.user.username, profilePicURL: url, identifier: strongSelf.user.username)
                    
                    ProgressHUD.showSuccess("Uploaded profile picture!")
                    
                    strongSelf.collectionView.reloadData()
                    
                case .failure:
                    
                    ProgressHUD.showError("Failed to upload profile picture.")
                    
                }
            }
            
        }
        
    }
    
    
}


