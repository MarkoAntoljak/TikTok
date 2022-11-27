//
//  ProfilePostCollectionViewCell.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/25/22.
//

import AVFoundation
import UIKit

class ProfilePostCollectionViewCell: UICollectionViewCell {
    
    // MARK: Attributes
    
    static let identifier = "ProfilePostCollectionViewCell"
    
    // MARK: UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //styling
        clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: Functions
    
    func configure(model post: PostModel) {
        
        StorageManager.shared.getVideoDownloadURL(for: post) { result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let url):
                
                    // setting image from video from storage downloaded url
                    
                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)
                    
                    do {
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        
                        self.imageView.image = UIImage(cgImage: cgImage)
        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
