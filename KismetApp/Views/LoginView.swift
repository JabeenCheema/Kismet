//
//  LoginView.swift
//  KismetApp
//
//  Created by Jabeen's MacBook on 2/22/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import UIKit

enum AccountLoginState {
    case newAccount
    case existingAccount
}

protocol LoginViewDelegate: AnyObject {
    func didSelectLoginButton(_ loginView: LoginView, accountLoginState:AccountLoginState)
}


class LoginView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var accountToggleMessageLabel: UILabel!
    
    private var tapGesture: UITapGestureRecognizer!
    private var accountLoginState = AccountLoginState.newAccount
    public weak var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        createButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        accountToggleMessageLabel.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        accountToggleMessageLabel.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func loginButtonPressed() {
        print("login button pressed with state: \(accountLoginState)")
        delegate?.didSelectLoginButton(self, accountLoginState: accountLoginState)
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        accountLoginState = accountLoginState == .newAccount ? .existingAccount : .newAccount
        switch accountLoginState {
        case .newAccount:
            createButton.setTitle("Create", for: .normal)
            accountToggleMessageLabel.text = "Log in to Kismet account"
        case .existingAccount:
            createButton.setTitle("Login", for: .normal)
            accountToggleMessageLabel.text = "New User? Create an account"
        }
    }
}
