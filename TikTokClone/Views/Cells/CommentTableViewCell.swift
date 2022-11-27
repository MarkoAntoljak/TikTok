//
//  CommentTableViewCell.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/13/22.
//

import UIKit
import SDWebImage

class CommentTableViewCell: UITableViewCell {

    // MARK: Attributes
    
    static let identifier = "CommentTableViewCell"
    
    // MARK: UI Elements
    
    private lazy var profileImg: UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.layer.cornerRadius = imageview.width / 2
        imageview.tintColor = .lightGray
        return imageview
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle ,reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        
        addSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setFrames()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImg.image = nil
        commentLabel.text = nil
        dateLabel.text = nil
        
    }
    
    // MARK: Functions
    
    private func addSubviews() {
        
        addSubview(profileImg)
        addSubview(commentLabel)
        addSubview(dateLabel)
        addSubview(usernameLabel)
        
    }
    
    private func setFrames() {
        
        // comment label
        commentLabel.sizeToFit()
        commentLabel.frame = CGRect(x: profileImg.right + 15, y: 0, width: commentLabel.width, height: commentLabel.height)
        commentLabel.center.y = contentView.center.y
        
        // username label
        usernameLabel.sizeToFit()
        usernameLabel.frame = CGRect(x: profileImg.right + 15, y: commentLabel.top - 15, width: usernameLabel.width, height: usernameLabel.height)
        
        // profile image
        let size: CGFloat = 50
        profileImg.frame = CGRect(x: 10, y: 0, width: size, height: size)
        profileImg.center.y = contentView.center.y
        
        // date label
        dateLabel.sizeToFit()
        dateLabel.frame = CGRect(x: profileImg.right + 20, y: commentLabel.bottom + 5, width: dateLabel.width, height: dateLabel.height)
        
    }

    // Configuration of cell content
    
    func configure(from model: CommentModel) {
        
        commentLabel.text = model.comment
        
        usernameLabel.text = model.user.username
        
        profileImg.image = UIImage(named: "imageTravis")
        
        // format date into string
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        dateLabel.text = formatter.string(from: model.date)
    
    }

}
