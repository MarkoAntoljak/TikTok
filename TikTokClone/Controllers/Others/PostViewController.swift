//
//  PostViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit

class PostViewController: UIViewController {
    
    // MARK: Attributes
    
    let model: PostModel
    
    // MARK: UI Elements
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    // MARK: Init

    init(model: PostModel) {
        
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let colors: [UIColor] = [.red, .blue]
        
        view.backgroundColor = colors.randomElement()
        
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addSubviews()
        setFrames()
    }
    
    
    // MARK: Functions
    
    private func addSubviews() {
        
        view.addSubview(likeButton)
        view.addSubview(shareButton)
        view.addSubview(commentButton)
    }
    
    private func setFrames() {
        
        let size: CGFloat = 45
        
        likeButton.frame = CGRect(
            x: view.width - size - 15,
            y: view.height - (size * 8),
            width: size,
            height: size - 10)
        
        commentButton.frame = CGRect(
            x: view.width - size - 15,
            y: view.height - (size * 6),
            width: size,
            height: size - 5)
        
        shareButton.frame = CGRect(
            x: view.width - size - 15,
            y: view.height - (size * 5) + 10,
            width: size,
            height: size - 5)
        
        
    }

}
