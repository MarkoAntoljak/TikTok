//
//  ProfileHeaderCollectionReusableView.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/21/22.
//

import UIKit
import SDWebImage

/// delegate for handling button actions
protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    
    func profileHeaderCollectionReusableViewDelegate(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButton viewModel: ProfileHeaderViewModel)
    
    func profileHeaderCollectionReusableViewDelegate(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButton viewModel: ProfileHeaderViewModel)
    
    func profileHeaderCollectionReusableViewDelegate(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButton viewModel: ProfileHeaderViewModel)
    
    func profileHeaderCollectionReusableViewDelegate(_ header: ProfileHeaderCollectionReusableView, didTapProfileImage viewModel: ProfileHeaderViewModel)
    
}

/// Header for profile collection view
class ProfileHeaderCollectionReusableView: UICollectionReusableView {
        
    // MARK: Attributes
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    private var viewModel: ProfileHeaderViewModel?
    
    // MARK: UI Elements
    
    private lazy var profileImage: UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.tintColor = .label
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    private lazy var primaryButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemPink
        return button
    }()
    
    private lazy var followersButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 4
        return button
    }()
    
    private lazy var followingButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 4
        return button
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // view configuration
        clipsToBounds = true
        backgroundColor = .systemBackground
    
        // add subviews
        addSubview(profileImage)
        addSubview(primaryButton)
        addSubview(followingButton)
        addSubview(followersButton)
        
        // add actions
        primaryButton.addTarget(self, action: #selector(didTapPrimary), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowing), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowers), for: .touchUpInside)
        
        // add tap gesture on profile image
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileAvatar))
        profileImage.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // profile image
        profileImage.frame = CGRect(x: 0, y: self.safeAreaInsets.top, width: 100, height: 100)
        profileImage.center.x = self.center.x
        profileImage.layer.cornerRadius = profileImage.height / 2
        
        
        // following/followers count buttons
        followersButton.frame = CGRect(x: 85, y: profileImage.bottom + 20, width: 100, height: 50)
        followingButton.frame = CGRect(x: followersButton.right + 20, y: profileImage.bottom + 20, width: 100, height: 50)
        
        // edit profile or follow button
        primaryButton.sizeToFit()
        primaryButton.frame = CGRect(x: 0, y: followingButton.bottom + 20, width: primaryButton.width + 100, height: primaryButton.height + 10)
        primaryButton.center.x = self.center.x
        
    }
    
    // MARK: Functions
    
    /// Configuring each cell with data
    /// - Parameter viewModel: data to configure
    public func configure(with viewModel: ProfileHeaderViewModel) {
        
        self.viewModel = viewModel
        
        // follow count
        followingButton.setTitle("Following\n\(viewModel.followingCount)", for: .normal)
        followersButton.setTitle("Followers\n\(viewModel.followersCount)", for: .normal)
        
        // profile image
        if let profileImageURL = viewModel.profileImageURL {
            
            profileImage.sd_setImage(with: profileImageURL)
            
        } else {
            
            profileImage.image = UIImage(systemName: "person.circle")
        }
        
        // Handle follow/unfollow button
        DispatchQueue.main.async {
            
            if let isFollowing = viewModel.isFollowing {
                
                if isFollowing {
                    
                    print("unfollow")
                    
                    // unfollow
                    self.primaryButton.setTitle("Unfollow", for: .normal)
                    self.primaryButton.backgroundColor = .secondarySystemBackground
                    
                } else {
                    
                    print("follow")
                    
                    // follow
                    self.primaryButton.setTitle("Follow", for: .normal)
                    self.primaryButton.backgroundColor = .systemPink
                }
                
            } else {
                
                // show edit profile
                self.primaryButton.backgroundColor = .secondarySystemBackground
                self.primaryButton.setTitle("Edit Profile", for: .normal)
                
            }
        }
        
    }
    
    // MARK: Button Actions
    @objc
    private func didTapPrimary() {
        
        guard let viewModel = viewModel else {return}
        
        delegate?.profileHeaderCollectionReusableViewDelegate(self, didTapPrimaryButton: viewModel)
        
    }
    
    @objc
    private func didTapFollowers() {
        
        guard let viewModel = viewModel else {return}
        
        delegate?.profileHeaderCollectionReusableViewDelegate(self, didTapFollowersButton: viewModel)
        
    }
    
    @objc
    private func didTapFollowing() {
        
        guard let viewModel = viewModel else {return}
        
        delegate?.profileHeaderCollectionReusableViewDelegate(self, didTapFollowingButton: viewModel)
        
    }
    
    @objc
    private func didTapProfileAvatar() {
        
        guard let viewModel = viewModel else {return}
        
        delegate?.profileHeaderCollectionReusableViewDelegate(self, didTapProfileImage: viewModel)
        
    }
    
    

}
