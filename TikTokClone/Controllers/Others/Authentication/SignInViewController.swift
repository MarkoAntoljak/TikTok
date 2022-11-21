//
//  SignInViewController.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import UIKit
import SafariServices

class SignInViewController: UIViewController {
    
    // MARK: Attributes
    
    // MARK: UI Elements
    private lazy var titleImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        imageview.backgroundColor = .white
        imageview.layer.cornerRadius = 10
        imageview.image = UIImage(named: "tiktok_text")
        return imageview
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
    
    private lazy var btnSignIn: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var btnSignUp: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var btnTerms: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var btnPrivacy: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // set delegates
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
        
        view.addSubview(titleImage)
        view.addSubview(tfEmail)
        view.addSubview(tfPassword)
        view.addSubview(btnSignIn)
        view.addSubview(btnSignUp)
        view.addSubview(btnTerms)
        view.addSubview(btnPrivacy)
        
    }
    
    private func setFrames() {
        
        
        titleImage.frame = CGRect(x: 0, y: view.safeAreaInsets.bottom + 50, width: 300, height: 100)
        titleImage.center.x = view.center.x
        
        tfEmail.frame = CGRect(x: 0, y: titleImage.bottom + 100, width: 300, height: 50)
        tfEmail.center.x = view.center.x
        
        tfPassword.frame = CGRect(x: 0, y: tfEmail.bottom + 25, width: 300, height: 50)
        tfPassword.center.x = view.center.x
        
        btnSignIn.frame = CGRect(x: 0, y: tfPassword.bottom + 25, width: 280, height: 50)
        btnSignIn.center.x = view.center.x
        
        btnSignUp.sizeToFit()
        btnSignUp.frame = CGRect(x: 0, y: btnSignIn.bottom + btnSignIn.height, width: btnSignUp.width, height: btnSignUp.height)
        btnSignUp.center.x = view.center.x
        
        btnTerms.sizeToFit()
        btnTerms.frame = CGRect(x: 0, y: btnSignUp.bottom + 50, width: btnTerms.width, height: btnTerms.height)
        btnTerms.center.x = view.center.x
        
        btnPrivacy.sizeToFit()
        btnPrivacy.frame = CGRect(x: 0, y: btnTerms.bottom + 10, width: btnPrivacy.width, height: btnPrivacy.height)
        btnPrivacy.center.x = view.center.x
        
    }
    
    private func addActions() {
        
        btnSignIn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        btnSignUp.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        btnTerms.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        btnPrivacy.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
        
    }
    
    // MARK: Actions
    
    @objc
    private func didTapSignIn() {
        
        signIn()
        
    }
    
    @objc
    private func didTapSignUp() {
        
        let vc = SignUpViewController()
        
        // if user registers present home screen
        vc.completion = { [weak self] in
                    
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
    
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc
    private func didTapTerms() {
        
        guard let url = URL(string: "https://www.tiktok.com/legal/terms-of-service-us?lang=en") else {return}
        
        let vc = SFSafariViewController(url: url)
        
        present(vc, animated: true)
    }
    
    @objc
    private func didTapPrivacy() {
        
        guard let url = URL(string: "https://www.tiktok.com/legal/page/us/privacy-policy/en") else {return}
        
        let vc = SFSafariViewController(url: url)
        
        present(vc, animated: true)
    }
    
    // MARK: Sign In
    
    private func signIn() {
        
        tfEmail.resignFirstResponder()
        tfPassword.resignFirstResponder()
        
        // check input of the user
        guard let email = tfEmail.text,
              let password = tfPassword.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              email.contains("@"),
              password.count >= 6 else {
            
            // show error to the user - wrong input
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oops...", message: "Wrong input, please check your email and password input fields.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true)
            }
            return
        }
        
        
        // try to sign in the user after input validation
        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            
            switch result {
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
                // show the error to the user - Firebase auth
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "There was a problem signing you in. Please check your email and password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self?.present(alert, animated: true)
                }
                return
                
            case .success(_):
                
                DispatchQueue.main.async {
                
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.dismiss(animated: true)
                    self?.present(vc, animated: true)
                    
                    
                }
                
            }
            
        }
        
        
    }
    
    
}

// MARK: UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == tfEmail {
                tfPassword.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                didTapSignIn()
            }
            return true
        }
}



