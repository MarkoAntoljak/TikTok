//
//  SignUpViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit
import SnapKit
import ProgressHUD

class SignUpViewController: UIViewController {
    
    // MARK: Attributes
    
    public var completion:(() -> Void)?
    
    // MARK: UI Elements
    
    private lazy var tfUsername: TikTokTextField = {
        let field = TikTokTextField()
        field.placeholder = "Username"
        field.returnKeyType = .next
        field.keyboardType = .default
        return field
    }()
    
    private lazy var tfEmail: TikTokTextField = {
        let field = TikTokTextField()
        field.placeholder = "Email address"
        field.returnKeyType = .next
        field.keyboardType = .emailAddress
        return field
    }()
    
    private lazy var tfPassword: TikTokTextField = {
        let field = TikTokTextField()
        field.placeholder = "Password"
        field.returnKeyType = .done
        field.isSecureTextEntry = true
        field.keyboardType = .default
        return field
    }()
    
    private lazy var btnSignUp: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var btnSignIn: UIButton = {
        let button = UIButton()
        button.setTitle("Already have account? Sign in", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Sign Up"
        
        // set delegates
        tfUsername.delegate = self
        tfEmail.delegate = self
        tfPassword.delegate = self
        
        addSubviews()
        addActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setFrames()
    }
    
    
    
    // MARK: Functions
    
    private func addSubviews() {
        
        view.addSubview(tfUsername)
        view.addSubview(tfEmail)
        view.addSubview(tfPassword)
        view.addSubview(btnSignUp)
        view.addSubview(btnSignIn)
        
    }
    
    
    private func addActions() {
        
        btnSignUp.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        btnSignIn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    
    private func setFrames() {
        
        tfUsername.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 50, width: 300, height: 50)
        tfUsername.center.x = view.center.x
        
        tfEmail.frame = CGRect(x: 0, y: tfUsername.bottom + 25, width: 300, height: 50)
        tfEmail.center.x = view.center.x
        
        tfPassword.frame = CGRect(x: 0, y: tfEmail.bottom + 25, width: 300, height: 50)
        tfPassword.center.x = view.center.x
        
        btnSignUp.frame = CGRect(x: 0, y: tfPassword.bottom + 25, width: 280, height: 50)
        btnSignUp.center.x = view.center.x
        
        btnSignIn.sizeToFit()
        btnSignIn.frame = CGRect(x: 0, y: btnSignUp.bottom + 50, width: btnSignUp.width, height: btnSignUp.height)
        btnSignIn.center.x = view.center.x
        
    }
    
    // MARK: Actions
    
    @objc
    private func didTapSignIn() {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    private func didTapSignUp() {
        
        tfUsername.resignFirstResponder()
        tfEmail.resignFirstResponder()
        tfPassword.resignFirstResponder()
        
        signUp()
        
    }
    
    // MARK: Sign Up
    
    private func signUp() {
        
        guard let username = tfUsername.text,
              let email = tfEmail.text,
              let password = tfPassword.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.contains("."),
              !username.contains(" "),
              username.count > 4,
              password.count >= 6,
              email.contains("@") else {
            
            // reset textfield
            tfUsername.text = nil
            tfEmail.text = nil
            tfPassword.text = nil
            
            // show error to the user - wrong input
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "Oops...", message: "Wrong input, please check all fields again. Username should have at least 4 charaters, no whitespaces or dots. Email must be valid. Password should be at least 6 characters long.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true)
                
            }
    
            return
        }
        
        ProgressHUD.show("Signing up")
        
        AuthManager.shared.signUp(username: username, email: email, password: password) { [weak self] signedUp in
            
            if signedUp {
                
                ProgressHUD.dismiss()
                
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(password, forKey: "password")
                
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "Congrats!", message: "You have been successfully signed up on TikTok.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel,handler: { action in
                        // if user signs up successfully show home screen, this is done on the sign in vc
                        self?.navigationController?.popViewController(animated: true)
                        self?.completion?()
                    }))
                    self?.present(alert, animated: true)
                    
                }
                
            } else {
                
                ProgressHUD.dismiss()
                // show error to the user - Firebase Auth
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "Oops...", message: "Wrong input, please check all fields again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .cancel))
                    self?.present(alert, animated: true)
                    return
                }
            }
            
            
        }
    }
    
    
}

// MARK: UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == tfUsername {
            
            tfEmail.becomeFirstResponder()
            
        } else if textField == tfEmail {
            
            tfPassword.becomeFirstResponder()
            
        } else {
            
            textField.resignFirstResponder()
            
            didTapSignIn()
            
        }
        return true
    }
}
