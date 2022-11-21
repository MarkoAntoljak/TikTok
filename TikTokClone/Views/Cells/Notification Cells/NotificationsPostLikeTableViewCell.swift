//
//  NotificationsPostLikeTableViewCell.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/20/22.
//

import UIKit

protocol NotificationsPostLikeTableViewCellDelegate: AnyObject {
    
    func notificationsPostLikeTableViewCellDelegate(_ cell: NotificationsPostLikeTableViewCell, post: PostModel)
    
}

class NotificationsPostLikeTableViewCell: UITableViewCell {

   
    // MARK: Attributes
    
    static let identifier = "NotificationsPostLikeTableViewCell"
    
    weak var delegate: NotificationsPostLikeTableViewCellDelegate?
    
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
        return label
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
        
        label.sizeToFit()
        label.frame = CGRect(x: 20, y: 10, width: label.width, height: label.height)
        
        dateLabel.sizeToFit()
        dateLabel.frame = CGRect(x: 20, y: label.bottom + 10, width: dateLabel.width, height: dateLabel.height)
        
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
        
        postImageView.image = UIImage(named: "test")
        
        postID = model.identifier
    }
    
    // MARK: Actions
    
    @objc
    private func didTapPost() {
        
        print("did tap post")
        
        guard let id = postID else {return}
        
        delegate?.notificationsPostLikeTableViewCellDelegate(self, post: PostModel(identifier: id))
    }
    

}
