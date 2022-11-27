//
//  RecordingCaptionViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/19/22.
//

import UIKit
import ProgressHUD

class RecordingCaptionViewController: UIViewController {
    
    
    // MARK: Attributes
    
    let videoURL: URL
    
    // MARK: UI Elements
    private lazy var textField: UITextView = {
        let field = UITextView()
        field.backgroundColor = .darkGray
        field.textColor = .white
        field.font = .systemFont(ofSize: 20)
        field.text = "Add caption..."
        field.layer.cornerRadius = 10
        field.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        return field
    }()
    
    
    // MARK: Init
    init(videoURL: URL) {
        
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        title = "Add Caption"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        // done button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        
        // add subviews
        textField.delegate = self
        view.addSubview(textField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        textField.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 200, width: view.width - 100, height: 100).integral
        textField.center.x = view.center.x
        
    }
    
    // MARK: Actions
    
    @objc
    private func didTapPost() {
        
        // handling caption
        textField.resignFirstResponder()
        
        var caption = textField.text ?? ""
        
        if caption == "Add caption..." {
            
            caption = ""
        }
        
        // show loader
        ProgressHUD.show("Posting")
        
        let videoName = StorageManager.shared.generateVideoName()
        
        StorageManager.shared.uploadVideoURL(from: videoURL, fileName: videoName, caption: caption) { [weak self] success in
            
            DatabaseManager.shared.insertVideo(fileName: videoName, caption: caption) { success in
                
                if success {
                    print("successfully added to database")
                } else {
                    print("error while adding to database")
                    return
                }
            }
            
            if success {
                
                ProgressHUD.showSuccess("Uploaded")
                
                DispatchQueue.main.async {
                    
                    // change back to home feed
                    self?.navigationController?.popViewController(animated: true)
                    self?.tabBarController?.selectedIndex = 0
                    self?.tabBarController?.tabBar.isHidden = false
                }
                
            } else {
                
                ProgressHUD.showError("Error")
                
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "Error", message: "Something went wrong when uploading video.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .cancel))
                    self?.present(alert, animated: true)
                    
                }
            }
        }
        
    }
    
    
    
    
}

// MARK: UITextViewDelegate
extension RecordingCaptionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
    }
}

