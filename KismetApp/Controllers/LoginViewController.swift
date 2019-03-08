//
//  ViewController.swift
//  KismetApp
//
//  Created by Jabeen's MacBook on 2/14/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var loginView: LoginView!
    
    private var userSession: UserSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        userSession = (UIApplication.shared.delegate as! AppDelegate).usersession
        userSession.userSessionAccountDelegate = self
        userSession.usersessionSignInDelegate = self
        goToVC()
        //presentKismetTabController()
    }
    func  goToVC(){
        loginView.createButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
    }
    @objc func goToLogin(){
        presentKismetTabController()
    }
}

extension LoginViewController: LoginViewDelegate {
    func didSelectLoginButton(_ loginView: LoginView, accountLoginState: AccountLoginState) {
      guard let email = loginView.emailTextfield.text,
        let password = loginView.passwordTextfield.text,
        !email.isEmpty,
        !password.isEmpty else {
            showAlert(title: "Missing Required Fields", message: "Email and Password Required", actionTitle: "Try Again" )
            return 
        }
        switch accountLoginState {
        case .newAccount:
            userSession.createNewAccount(email: email, password: password)
            //present(SetupProfileViewController(), animated: true)
        case .existingAccount:
            userSession.signInExistingUser(email: email, password: password)
        }
    }
}

extension LoginViewController: UserSessionAccountCreationDelegate {
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription, actionTitle: "Try Again")
        }

    func didCreateAccount(_ userSession: UserSession, user: User) {
        showAlert(title: "Account Created", message: "Account created using \(user.email ?? "no email entered") ", style: .alert) { (alert) in }
        //self.presentKismetTabController()
        let storyboard = UIStoryboard.init(name: "KismetTab", bundle: nil)
        let setupprofileVC = storyboard.instantiateViewController(withIdentifier: "SetupProfileViewController") as! SetupProfileViewController
        present(setupprofileVC, animated: true, completion: nil)
    }
}

extension LoginViewController: UserSessionSignInDelegate {
    func didRecieveSignInError(_ usersession: UserSession, error: Error) {
        showAlert(title: "Sign in Error", message: error.localizedDescription, actionTitle: "Try Again")
    }
    
    func didSignInExistingUser(_ usersession: UserSession, user: User) {
        self.presentKismetTabController()
    }
    
    private func presentKismetTabController() {
        let storyboard = UIStoryboard(name: "KismetTab", bundle: nil)
        let kismetTabController = storyboard.instantiateViewController(withIdentifier: "SetupProfileViewController") as! SetupProfileViewController
        kismetTabController.modalTransitionStyle = .crossDissolve
        kismetTabController.modalPresentationStyle = .overFullScreen
        self.present(kismetTabController, animated: true)
    }
}








   
    



    

