//
//  NotificationsPostCommentTableViewCell.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/20/22.
//

import UIKit

/// delegate for notification post comment cell
protocol NotificationsPostCommentTableViewCellDelegate: AnyObject {
    
    func notificationsPostCommentTableViewCellDelegate(_ cell: NotificationsPostCommentTableViewCell, post: PostModel)
    
}

class NotificationsPostCommentTableViewCell: UITableViewCell {

    // MARK: Attributes
    
    static let identifier = "NotificationsPostCommentTableViewCell"
    
    weak var delegate: NotificationsPostCommentTableViewCellDelegate?
    
    private var postID: String?
    
    // MARK: UI Elements
    
    private lazy var postImageView: UIImageView = {
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
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        selectionStyle = .none
        
        // add subviews
        contentView.addSubview(postImageView)
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        
        // make post clickable
        postImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // text label
        label.sizeToFit()
        label.frame = CGRect(x: 20, y: 10, width: label.width, height: label.height)
        
        // date label
        dateLabel.sizeToFit()
        dateLabel.frame = CGRect(x: 20, y: label.bottom + 10, width: dateLabel.width, height: dateLabel.height)
        
        // post image
        postImageView.frame = CGRect(x: contentView.right - 70, y: 0, width: 50, height: 50)
        postImageView.center.y = contentView.center.y
        postImageView.layer.cornerRadius = 10
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    
    // MARK: Functions
    
    func configure(postFileName: String, model: NotificationModel) {
        
        label.text = model.text
        
        let dateString = DateFormatter.localizedString(from: model.date, dateStyle: .medium, timeStyle: .short)
        
        dateLabel.text = dateString
        
        postImageView.image = UIImage(named: "imageTravis")
        
        postID = model.identifier
    }
    
    // MARK: Button Actions
    
    @objc
    private func didTapPost() {
        
        guard let id = postID else {return}
        
        delegate?.notificationsPostCommentTableViewCellDelegate(self, post: PostModel(identifier: id, user: UserModel(username: "travisssss", profilePicURL: nil, identifier: UUID().uuidString)))
        
    }

    
    


}
