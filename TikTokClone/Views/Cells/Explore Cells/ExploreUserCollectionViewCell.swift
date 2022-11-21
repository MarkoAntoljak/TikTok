//
//  ExploreUserCollectionViewCell.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/14/22.
//

import UIKit

class ExploreUserCollectionViewCell: UICollectionViewCell {
    
    // MARK: Propreties
    
    static let identifier = "ExplorePostCollectionViewCell"
    
    // MARK: UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 10
        imageview.layer.masksToBounds = true
        return imageview
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        return label
    }()

    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        
        imageView.frame = contentView.bounds
        
        addSubview(imageView)
        addSubview(label)
    
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height - 30)
        
        label.sizeToFit()
        label.frame = CGRect(x: 4, y: imageView.bottom, width: label.width, height: label.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        label.text = nil
    }
    
    // MARK: Functions
    
    func configure(with viewModel: ExploreUserViewModel) {
        
        
        imageView.image = viewModel.profilePic
        
        label.text = "\(String(viewModel.followerCount)) \nfollowers"
    
    }
    
    
}
