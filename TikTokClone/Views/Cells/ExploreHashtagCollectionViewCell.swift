//
//  ExploreHashtagCollectionViewCell.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/14/22.
//

import UIKit

class ExploreHashtagCollectionViewCell: UICollectionViewCell {
    
    // MARK: Propreties
    
    static let identifier = "ExploreHashtagCollectionViewCell"
    
    // MARK: UI Elements
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        
        addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 0, width: label.width, height: label.height)
        label.center.y = contentView.center.y
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }
    
    // MARK: Functions
    
    func configure(with viewModel: ExploreHashtagViewModel) {
        
        label.text = viewModel.text
        
    }
}
