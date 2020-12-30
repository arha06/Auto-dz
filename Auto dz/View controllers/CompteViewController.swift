//
//  CompteViewController.swift
//  Auto dz
//
//  Created by hadj aissa hadj said on 26.12.2020.
//

import UIKit
import FirebaseAuth

class CompteViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - showAfterLogginInViewController
    func showAfterLogginInViewController() {
        let vc = storyboard?.instantiateViewController(identifier: "other") as! AfterLoginInViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = " Email Address"
        emailField.layer.borderWidth = 1
        emailField.autocapitalizationType = .none
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0) )
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.backgroundColor = .white
        return emailField
    }()
    
    private let passwordField: UITextField = {
        let passField = UITextField()
        passField.placeholder = " Password"
        passField.layer.borderWidth = 1
        passField.isSecureTextEntry = true
        passField.layer.borderColor = UIColor.black.cgColor
        passField.backgroundColor = .white
        passField.leftViewMode = .always
        passField.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0) )
        return passField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(button)
        
        passwordField.delegate = self
        emailField.delegate = self
        
        view.backgroundColor = .systemPurple
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            showAfterLogginInViewController()
            
        }
    }
    
    @objc private func didTapButton() {
        print("Button Tapped")
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty
        else {
            let alert = UIAlertController(title: "Textfields are empty", message: "Please, enter your e-mail and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            print("Missing data")
            return
        }
        
        // Get auth instance
        // attempt sign in
        // if failure, present alert to create account
        // if user continues, create account
        
        // check sign in on app launch
        // allow user to sign out with button
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                // show account creation
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            print("You have signed in ")
            self?.showAfterLogginInViewController()
        })
    }
    
    //MARK:- GET RID OF CLAVIATURE AFTER FILLING INFORMATION 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    // MARK:- func showCreateAccount
    func showCreateAccount(email: String, password: String){
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                guard let strongSelf = self else {
                    return
                }
                
                guard error == nil else {
                    // show account creation
                    print("Account Creation failed")
                    return
                }
                print("You have signed in")
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))
        
        present(alert, animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRect(x: 0,
                             y: 100,
                             width: view.frame.size.width,
                             height: 80)
        emailField.frame = CGRect(x: 20,
                                  y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width-40,
                                  height: 50)
        
        passwordField.frame = CGRect(x: 20,
                                     y:emailField.frame.origin.y+emailField.frame.size.height+10,
                                     width: view.frame.size.width-40,
                                     height: 50)
        
        button.frame = CGRect(x: 20,
                              y:passwordField.frame.origin.y+passwordField.frame.size.height+30,
                              width: view.frame.size.width-40,
                              height: 50)
        
    }
}

//MARK:- AfterLoginInViewController

class AfterLoginInViewController: UIViewController {
    
    
    func showCompteViewControllerAfterLogginOut() {
        let vc = storyboard?.instantiateViewController(identifier: "tabBar") as! TabBarViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log Out", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(signOutButton)
        
        signOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
    }
    
    // MARK: - func logOutTapped()
    
    @objc func logOutTapped() {
        print("you logged out")
        do {
            try FirebaseAuth.Auth.auth().signOut()
            showCompteViewControllerAfterLogginOut()
            
        }
        catch {
            print("An error Accurred")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signOutButton.frame = CGRect(x: 20, y: 150, width: view.frame.size.width-40, height: 52)
        
    }
}
