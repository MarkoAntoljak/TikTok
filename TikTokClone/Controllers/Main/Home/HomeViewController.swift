//
//  HomeViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Attributes
    
    private lazy var followingPosts = PostModel.mockModels()
    
    private lazy var forYouPosts = PostModel.mockModels()
    
    // displayed posts
    private var currentPosts: [PostModel] {
        
        // user is on Following feed
        if horizontalScrollView.contentOffset.x == 0 {
            
            return followingPosts
            
        }
        
        // user is on For You feed
        return forYouPosts
        
    }
    
    // MARK: UI Elements
    
    // controling headers
    private lazy var control: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = .systemBackground
        control.tintColor = .secondarySystemBackground
        return control
    }()
    
    // following feed scroll controller
    private lazy var followingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical)
    
    // for you feed scroll controller
    private lazy var forYouPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical)
    
    // horizontal scroll view
    private lazy var horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.backgroundColor = .systemBackground
        scrollView.isPagingEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view background
        view.backgroundColor = .systemBackground
        
        // set page controllers
        followingPageViewController.didMove(toParent: self)
        forYouPageViewController.didMove(toParent: self)
        horizontalScrollView.delegate = self
        
        // navigation title
        navigationItem.titleView = control
        control.addTarget(self, action: #selector(didChangeHeader(_:)) , for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpFrames()
        setUpForYouFeed()
        setUpFollowingFeed()
        addSubviews()
        
    }
    
    // MARK: Functions
    
    private func addSubviews() {
        
        view.addSubview(horizontalScrollView)
        
    }
    
    // set up all UI elements frames
    private func setUpFrames() {
        
        let horizontalScrollView = horizontalScrollView
        
        horizontalScrollView.frame = view.bounds
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        
        followingPageViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: horizontalScrollView.width,
            height: horizontalScrollView.height)
        
        forYouPageViewController.view.frame = CGRect(
            x: view.width,
            y: 0,
            width: horizontalScrollView.width,
            height: horizontalScrollView.height)
        
        
    }
    
    // setting up following feed
    private func setUpFollowingFeed() {
        
        guard let model = followingPosts.first else {return}
        
        let vc = PostViewController(model: model)
        vc.delegate = self
        
        followingPageViewController.setViewControllers([vc], direction: .forward, animated: false)
        followingPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(followingPageViewController.view)
        inputViewController?.addChild(followingPageViewController)
        
    }
    
    // setting up for you feed
    private func setUpForYouFeed() {
        
        guard let model = forYouPosts.first else {return}
        
        let vc = PostViewController(model: model)
        vc.delegate = self
        
        forYouPageViewController.setViewControllers([vc], direction: .forward, animated: false)
        forYouPageViewController.dataSource = self
        
        
        horizontalScrollView.addSubview(forYouPageViewController.view)
        inputViewController?.addChild(forYouPageViewController)

    }
        
    
    // MARK: Button Actions
    
    @objc
    private func didChangeHeader(_ sender: UISegmentedControl) {
        
        horizontalScrollView.setContentOffset(CGPoint(
            x: view.width * CGFloat(sender.selectedSegmentIndex),
            y: 0), animated: true)
        
    }
        
}

// MARK: UIPageViewControllerDataSource

extension HomeViewController: UIPageViewControllerDataSource {
    
    // Going to previous post, scrolling down
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let fromPost = (viewController as? PostViewController)?.model else {return nil}
        
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {return nil}
        
        if index == 0 {return nil}
        
        let priorIndex = index - 1
        
        let model = currentPosts[priorIndex]
        
        let vc = PostViewController(model: model)
        return vc
    }
    
    
    // Going to next post, scrolling up
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let fromPost = (viewController as? PostViewController)?.model else {return nil}
        
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {return nil}
        
        guard index < (currentPosts.count - 1) else {return nil}
        
        let nextIndex = index + 1
        
        let model = currentPosts[nextIndex]
        
        let vc = PostViewController(model: model)
        return vc
    }
    
    
}


// MARK: UIScrollViewDelegate
// changing headers depending on the scroll of the user
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x < (view.width / 2) {
            
            control.selectedSegmentIndex = 0
            
        } else if scrollView.contentOffset.x > (view.width / 2) {
            
            control.selectedSegmentIndex = 1
            
        }
        
    }
}

extension HomeViewController: PostViewControllerDelegate {
    
    // did tap on profile icon
    func postViewControllerDelegateDidTapProfile(model: PostModel, vc: PostViewController) {
        
        DispatchQueue.main.async {
            
            let vc = ProfileViewController(user: model.user)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}

