//
//  NotificationsViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit

/// notifications in activity view controller
class NotificationsViewController: UIViewController {
    
    // MARK: Attributes
    
    private lazy var notifications = [NotificationModel]()
    
    // MARK: UI Elements
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(NotificationsPostLikeTableViewCell.self, forCellReuseIdentifier: NotificationsPostLikeTableViewCell.identifier)
        table.register(NotificationsPostCommentTableViewCell.self, forCellReuseIdentifier: NotificationsPostCommentTableViewCell.identifier)
        table.register(NotificationsUserFollowTableViewCell.self, forCellReuseIdentifier: NotificationsUserFollowTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "No Notifications"
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.isHidden = true
        return label
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Notifications"
        
        tabBarController?.tabBar.backgroundColor = .systemBackground
        
        // add subviews
        view.addSubview(label)
        view.addSubview(tableView)
        view.addSubview(spinner)
        
        // adding refresh when pull
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
        
        // fetching data
        fetchNotifications()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        label.center = view.center
        
        tableView.frame = view.bounds
        
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    
    // MARK: Functions
    private func fetchNotifications() {
        
        DatabaseManager.shared.fetchNotifications { [weak self] notifications in
            
            DispatchQueue.main.async {
                
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                
                self?.notifications = notifications
                
                self?.updateUI()
            }
            
        }
        
    }
    
    private func updateUI() {
        
        if notifications.isEmpty {
            
            label.isHidden = false
            tableView.isHidden = true
            
        } else {
            
            label.isHidden = true
            tableView.isHidden = false
            
        }
        
        tableView.reloadData()
        
    }
    
    // MARK: Actions
    
    // pull to refresh action
    @objc
    private func didRefresh(_ sender: UIRefreshControl) {
        
        sender.beginRefreshing()
        
        DatabaseManager.shared.fetchNotifications(completion: { [weak self] notifications in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                self?.notifications = notifications
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
        })
    }
    


}


// MARK: DELEGATES

// MARK: UITableViewDelegate, UITableViewDataSource

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    // configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = notifications[indexPath.row]
        
        switch model.type {
            
            
            // if notification is post like
        case .postLike(postName: let postName):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsPostLikeTableViewCell.identifier, for: indexPath) as? NotificationsPostLikeTableViewCell else {return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
            
            cell.configure(postFileName: postName, model: model)
            cell.delegate = self
            
            return cell
            
            
            // if notification is post comment
        case .postComment(postName: let postName):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsPostCommentTableViewCell.identifier, for: indexPath) as? NotificationsPostCommentTableViewCell else {return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
            
            cell.configure(postFileName: postName, model: model)
            cell.delegate = self
            
            return cell
            
            
            // if notification is user follow
        case .userFollow(username: let username):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsUserFollowTableViewCell.identifier, for: indexPath) as? NotificationsUserFollowTableViewCell else {return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)}
            
            cell.configure(username: username, model: model)
            cell.delegate = self
            
            return cell
            
        }
        
        
    }
    
    // selection of row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // editing enabled
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {return}
        
        let model = notifications[indexPath.row]
        
        model.isHidden = true
        
        DatabaseManager.shared.removenotification(notificationID: model.identifier) { [weak self] success in
            
            if success {
                
                DispatchQueue.main.async {
                    self?.notifications = self?.notifications.filter({$0.isHidden == false}) ?? []
                    
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                }
            }
            
        }
        
    }
    
}


// MARK: NotificationsUserFollowTableViewCellDelegate

extension NotificationsViewController: NotificationsUserFollowTableViewCellDelegate {
    
    func notificationsUserFollowTableViewCellDelegate(_ cell: NotificationsUserFollowTableViewCell, didTapFollowFor username: String) {
        
        DatabaseManager.shared.updateRelationship(
            for: UserModel(username: username, profilePicURL: nil, identifier: UUID().uuidString),
            follow: true) { success in
                
            if !success {
                
                print("Error: Something went wrong.")
            }
        }
        
    }
    
    func notificationsUserFollowTableViewCellDelegate(_ cell: NotificationsUserFollowTableViewCell, didTapUser username: String) {
        
        DispatchQueue.main.async {
                
            let vc = ProfileViewController(user: UserModel(username: username, profilePicURL: nil, identifier: "123"))
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
}

// MARK: NotificationsPostLikeTableViewCellDelegate

extension NotificationsViewController: NotificationsPostLikeTableViewCellDelegate {
    
    func notificationsPostLikeTableViewCellDelegate(_ cell: NotificationsPostLikeTableViewCell, post: PostModel) {
        
        DispatchQueue.main.async {
            
            let vc = PostViewController(model: PostModel(identifier: post.identifier, user: UserModel(username: "kanye", profilePicURL: nil, identifier: UUID().uuidString)))
            vc.title = post.user.username
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


// MARK: NotificationsPostCommentTableViewCellDelegate

extension NotificationsViewController: NotificationsPostCommentTableViewCellDelegate {
    func notificationsPostCommentTableViewCellDelegate(_ cell: NotificationsPostCommentTableViewCell, post: PostModel) {
        
        DispatchQueue.main.async {
            
            let vc = PostViewController(model: PostModel(identifier: post.identifier, user: UserModel(username: "kanye", profilePicURL: nil, identifier: UUID().uuidString)))
            vc.title = post.user.username
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


