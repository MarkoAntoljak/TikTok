//
//  NotificationsUserFollowTableViewCell.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/20/22.
//

import UIKit

protocol NotificationsUserFollowTableViewCellDelegate: AnyObject {
    
    func notificationsUserFollowTableViewCellDelegate(_ cell: NotificationsUserFollowTableViewCell, didTapFollowFor username: String)
    
    func notificationsUserFollowTableViewCellDelegate(_ cell: NotificationsUserFollowTableViewCell, didTapUser username: String)
}

class NotificationsUserFollowTableViewCell: UITableViewCell {

    
    // MARK: Attributes
    
    static let identifier = "NotificationsUserFollowTableViewCell"
    
    weak var delegate: NotificationsUserFollowTableViewCellDelegate?
    
    private var username: String?
    
    private var isFollowing = false
    
    // MARK: UI Elements
    
    private lazy var profileAvatar: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.masksToBounds = true
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private lazy var btnFollow: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        selectionStyle = .none
        
        // add subviews
        contentView.addSubview(profileAvatar)
        contentView.addSubview(label)
        contentView.addSubview(btnFollow)
        contentView.addSubview(dateLabel)
        
        // add button action
        btnFollow.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
        
        // make profile avatar clickable
        profileAvatar.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileAvatar))
        profileAvatar.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileAvatar.frame = CGRect(x: 20, y: 0, width: 40, height: 40)
        profileAvatar.center.y = contentView.center.y
        profileAvatar.layer.cornerRadius = profileAvatar.height / 2
        
        label.sizeToFit()
        label.frame = CGRect(x: profileAvatar.right + 20, y: label.height - 10, width: label.width, height: label.height)
        
        dateLabel.sizeToFit()
        dateLabel.frame = CGRect(x: profileAvatar.right + 20, y: profileAvatar.bottom - dateLabel.height, width: dateLabel.width, height: dateLabel.height)
        
        btnFollow.sizeToFit()
        btnFollow.frame = CGRect(x: contentView.right - btnFollow.width - 50, y: 0, width: btnFollow.width + 40, height: btnFollow.height)
        btnFollow.center.y = contentView.center.y
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileAvatar.image = nil
        label.text = nil
        dateLabel.text = nil
        
        btnFollow.setTitle("Follow", for: .normal)
        btnFollow.layer.borderColor = nil
        btnFollow.backgroundColor = .systemBlue
        btnFollow.layer.borderWidth = 0
        
    }
    
    
    // MARK: Functions
    
    func configure(username: String, model: NotificationModel) {
        
        self.username = username
        
        label.text = model.text
        
        profileAvatar.image = UIImage(named: "test")
        
        let dateString = DateFormatter.localizedString(from: model.date, dateStyle: .medium, timeStyle: .short)
        dateLabel.text = dateString
        
    }
    
    // MARK: Actions
    @objc
    private func didTapFollow() {
    
        guard let username = username else {return}
        
        delegate?.notificationsUserFollowTableViewCellDelegate(self, didTapFollowFor: username)
        
        if isFollowing {
           
            btnFollow.setTitle("Follow", for: .normal)
            btnFollow.layer.borderColor = nil
            btnFollow.backgroundColor = .systemBlue
            btnFollow.layer.borderWidth = 0
            btnFollow.setTitleColor(.white, for: .normal)
            
            isFollowing = false
            
        } else {
            btnFollow.setTitle("Following", for: .normal)
            btnFollow.layer.borderColor = UIColor.darkGray.cgColor
            btnFollow.backgroundColor = .clear
            btnFollow.layer.borderWidth = 1
            btnFollow.setTitleColor(.darkGray, for: .normal)
            
            isFollowing = true
        }
        
    }
    
    @objc
    private func didTapProfileAvatar() {
        
        guard let username = username else {return}
        
        delegate?.notificationsUserFollowTableViewCellDelegate(self, didTapUser: username)
    }



}
