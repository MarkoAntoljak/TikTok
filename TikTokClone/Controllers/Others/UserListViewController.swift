//
//  UserListViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Attributes
    
    enum ListType: String {
        
        case followers
        case following
    }
    
    public lazy var users = [String]()
    
    let user: UserModel
    
    let type: ListType
    
    
    // MARK: UI Elements
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private lazy var noUsersLabel: UILabel = {
        let label = UILabel()
        label.text = "No users"
        label.textColor = .secondarySystemBackground
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: Init
    
    init(user: UserModel, type: ListType) {
        self.user = user
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        switch type {
        case .followers:
            title = "Followers"
        case .following:
            title = "Following"
        }
        
        view.addSubview(tableView)
        view.addSubview(noUsersLabel)
        
        if users.isEmpty {
            
            noUsersLabel.isHidden = false
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        
        noUsersLabel.sizeToFit()
        noUsersLabel.frame = CGRect(x: 0, y: 0, width: noUsersLabel.width, height: noUsersLabel.height)
        noUsersLabel.center = view.center
        
    }
    
    // MARK: Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .secondarySystemBackground
        
        cell.textLabel?.text = users[indexPath.row]
        
        cell.textLabel?.textColor = .label
        
        return cell
    }
    
    // selection of rows
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    // MARK: Actions


}
