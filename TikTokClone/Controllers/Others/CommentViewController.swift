//
//  CommentViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/13/22.
//

import UIKit

class CommentViewController: UIViewController {
    
    // MARK: Attributes
    
    private var post: PostModel
    
    private var comments =  [CommentModel]()
    
    // MARK: UI Elements
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return table
    }()

    private lazy var navBar: UINavigationBar = {
        let navbar = UINavigationBar()
        navbar.tintColor = .black
        navbar.backgroundColor = .clear
        navbar.items = [UINavigationItem(title: "Comments")]
        return navbar
    }()

    
    // MARK: Init
    init(post: PostModel) {
        
        self.post = post
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        // Table View
        view.addSubview(navBar)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        setFrames()
        fetchPostComments()
    }
    
    // MARK: Functions
    
    // fetch all comments for current post
    private func fetchPostComments() {
        
        comments = CommentModel.mockComments()
        
    }
    
    private func setFrames() {
        
        navBar.frame = CGRect(x: 0, y: 0, width: view.width, height: 50)
        tableView.frame = CGRect(x: 0, y: navBar.height, width: view.width, height: view.height)
        
    }
 
}


// MARK: UITableViewDelegate, UITableViewDataSource

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Functions

    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    // row cell config
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = comments[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(from: comment)
        
        return cell
    }
    
    // row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
        
    }
    
    // row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
