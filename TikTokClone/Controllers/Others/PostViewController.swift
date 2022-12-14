//
//  PostViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit
import AVFoundation

/// delegate for tapping on profile avatar
protocol PostViewControllerDelegate: AnyObject {
    
    func postViewControllerDelegateDidTapProfile(model: PostModel, vc: PostViewController)
    
}

/// post view controller,
/// view controller that is on top of home vc
class PostViewController: UIViewController {
    
    // MARK: Attributes
    
    var model: PostModel
    
    private var player: AVPlayer?
    
    private var isVideoFinished: NSObjectProtocol?
    
    weak var delegate: PostViewControllerDelegate?
    
    // MARK: UI Elements
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    
    private lazy var profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "person.circle"), for: .normal)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.tintColor = .white
        return button
    }()
    
    // animated heart on double tap
    private lazy var heartImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.alpha = 0
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return imageView
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "paperplane"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Check out my new video!! #new #video"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        // label shadow
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 6.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 6, height: 6)
        return label
    }()
    
    private lazy var videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
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
        
        configureVideo()
        
        view.backgroundColor = .black
        
        navigationController?.tabBarController?.tabBar.backgroundColor = .systemBackground
        
        profileButton.setBackgroundImage(UIImage(named: "test"), for: .normal)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addSubviews()
        setFrames()
        addActions()
    }
    
    
    // MARK: Functions
    
    private func addSubviews() {
        
        videoView.addSubview(spinner)
        view.addSubview(videoView)
        view.addSubview(likeButton)
        view.addSubview(shareButton)
        view.addSubview(commentButton)
        view.addSubview(heartImage)
        view.addSubview(captionLabel)
        view.addSubview(profileButton)
        
    }
    
    private func setFrames() {
        
        let size: CGFloat = 40
        let x = CGFloat(view.width - size - 10)
        
        videoView.frame = view.bounds
        
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
        
        profileButton.frame = CGRect(
            x: x + 1,
            y: view.bottom - (size * 10),
            width: size,
            height: size)
        profileButton.layer.cornerRadius = profileButton.width / 2
        
        likeButton.frame = CGRect(
            x: x,
            y: profileButton.bottom + size,
            width: size,
            height: size - 10)
        
        commentButton.frame = CGRect(
            x: x,
            y: likeButton.bottom + size,
            width: size,
            height: size - 5)
        
        shareButton.frame = CGRect(
            x: x,
            y: commentButton.bottom + size,
            width: size,
            height: size - 5)
        
        captionLabel.sizeToFit()
        let lableSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(
            x: 10,
            y: view.bottom - (lableSize.height * 7) - (tabBarController?.tabBar.height ?? 0),
            width: view.width - size - 12,
            height: captionLabel.height)
        
    }
    
    private func addActions() {
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
    }
    
    // MARK: Button Actions
    
    @objc
    private func didTapProfile() {
        
        delegate?.postViewControllerDelegateDidTapProfile(model: model, vc: self)
        
    }
    
    // heart icon handling
    @objc
    private func didTapLike() {
        
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        
        DispatchQueue.main.async {
            
            if self.model.isLikedByCurrentUser {
                
                self.likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.likeButton.tintColor = .systemRed
                
            } else {
                
                self.likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                self.likeButton.tintColor = .white
            }
        }
    }
    
    // comments
    @objc
    private func didTapComment() {
        
        // add comment vc
        DispatchQueue.main.async {
            
            let vc = CommentViewController(post: self.model)
            self.present(vc, animated: true)
        }
        
    }
    
    // sharing
    @objc
    private func didTapShare() {
        
        DispatchQueue.main.async {
            guard let url = URL(string: "https://www.tiktok.com" ) else {return}
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
            self.present(vc, animated: true)
        }
        
    }
    
    
    @objc
    private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
        }
        
        // make herat button icon sync with double tap
        if model.isLikedByCurrentUser {
            
            DispatchQueue.main.async {
                
                self.likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.likeButton.tintColor = .systemRed
            }
        }
        
        // make image appear on tap loaction
        let touchPoint = gesture.location(in: view)
        
        heartImage.center = touchPoint
        
        DispatchQueue.main.async {
            self.heartAnimation()
        }

    }
    
    // animation for heart when double tapped
    private func heartAnimation() {
        
        UIView.animate(withDuration: 0.2) {
            
            self.heartImage.alpha = 1
            
        } completion: { done in
            
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                    UIView.animate(withDuration: 0.2) {
                        
                        self.heartImage.alpha = 0
                        
                    } completion: { done in
                        
                        if done {
                            self.heartImage.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Video Configuration
    
    private func configureVideo() {
        
        StorageManager.shared.getVideoDownloadURL(for: model) { [weak self] result in
            
            // reference counting fix
            guard let strongSelf = self else {return}
            
            DispatchQueue.main.async {
                
                strongSelf.spinner.stopAnimating()
                strongSelf.spinner.removeFromSuperview()
                
                switch result {
                    
                case .success(let url):
                    
                    strongSelf.player = AVPlayer(url: url)
                    
                    // displaying video
                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
                    
                    playerLayer.frame = strongSelf.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    
                    strongSelf.player?.volume = 0
                    strongSelf.player?.play()
                    
                    // replaying video
                    strongSelf.isVideoFinished = NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: strongSelf.player?.currentItem, queue: .main, using: { _ in
                            strongSelf.player?.seek(to: .zero)
                            strongSelf.player?.play()
                        })
                    
                case .failure(_):
                    
                    guard let path = Bundle.main.path(forResource: "testVideo", ofType: "mp4") else {
                        print("cannot find video")
                        return
                    }
                    
                    // create url to pass into player
                    let url = URL(fileURLWithPath: path)
                    
                    strongSelf.player = AVPlayer(url: url)
                    
                    // displaying video
                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
                    
                    playerLayer.frame = strongSelf.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    
                    strongSelf.player?.volume = 0
                    strongSelf.player?.play()
                    
                    // replaying video
                    strongSelf.isVideoFinished = NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: strongSelf.player?.currentItem, queue: .main, using: { _ in
                            strongSelf.player?.seek(to: .zero)
                            strongSelf.player?.play()
                        })
                }
            }
        }
        
    }
    
    
}

// MARK: PostViewControllerDelegate

extension ProfileViewController: PostViewControllerDelegate {
    
    func postViewControllerDelegateDidTapProfile(model: PostModel, vc: PostViewController) {
        
        DispatchQueue.main.async {
            
            let vc = ProfileViewController(user: model.user)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

