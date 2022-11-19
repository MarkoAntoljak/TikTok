//
//  ExploreFeaturedCollectionViewCell.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/14/22.
//

import UIKit

class ExploreFeaturedCollectionViewCell: UICollectionViewCell {
    
    // MARK: Propreties
    
    static let identifier = "ExploreFeaturedCollectionViewCell"
    
    // MARK: UI Elements

    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 5.0
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        
        // add subviews
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        
        // rounded corners
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    // set frames for ui elements
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
        
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: contentView.height - 5 - label.height, width: label.width, height: label.height)
        
        contentView.bringSubviewToFront(label)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        label.text = nil
    }
    
    // MARK: Functions
    
    func configure(with viewModel: ExploreFeaturedViewModel) {
        
        imageView.image = viewModel.image
        
        label.text = viewModel.caption
    }



}
