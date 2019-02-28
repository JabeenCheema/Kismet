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
        
    }


}

extension LoginViewController: LoginViewDelegate {
    func didSelectLoginButton(_ loginView: LoginView, accountLoginState: AccountLoginState) {
      guard let email = loginView.emailTextfield.text,
        let password = loginView.passwordTextfield.text,
        !email.isEmpty,
        !password.isEmpty else {
            showAlert(title: "Missing Required Fields", message: "Email and Password Required" )
            return 
        }
        switch accountLoginState {
        case .newAccount:
            userSession.createNewAccount(email: email, password: password)
        case .existingAccount:
            userSession.signInExistingUser(email: email, password: password)
        }
    }
}

extension LoginViewController: UserSessionAccountCreationDelegate {
    func didCreateAccount(_ userSession: UserSession, user: User) {
//        showAlert(title: "Account Created", message: "Account created using \(user.email ?? "no email entered") ") { alertController in
//            let okAction = UIAlertAction(title: "Ok", style: .default) { alert in
//                self.presentRaceReviewsTabController()
//            }
//            alertController.addAction(okAction)
//            self.present(alertController, animated: true)
//        }
    }
    
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
    
    
}
    
    


