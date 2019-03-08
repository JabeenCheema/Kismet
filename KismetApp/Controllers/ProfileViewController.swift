//
//  ProfileViewController.swift
//  KismetApp
//
//  Created by Jabeen's MacBook on 3/5/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class ProfileViewController: UITableViewController {

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    var usersession: UserSession!
    var storageManager: StorageManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        storageManager = (UIApplication.shared.delegate as! AppDelegate).storageManager
        
        
//         set the delegate for sign out
        usersession.usersessionSignOutDelegate = self
//        storageManager.delegate = self
        
        guard let user = usersession.getCurrentUser() else {
            emailLabel.text = "no logged user"
            return
        }
        emailLabel.text = user.email ?? "no email found for logged user"
        
        guard let photoURL = user.photoURL else {
            print("no photoURL")
            return
        }
    }
    
    @IBAction func signOutButonPressed(_ sender: UIButton) {
        usersession.signOut()
        
    }
}

extension ProfileViewController: UserSessionSignOutDelegate {
    func didRecieveSignOutError(_ usersession: UserSession, error: Error) {
        
    }
    
    func didSignOutUser(_ usersession: UserSession) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        present(loginVC, animated: true, completion: nil)
    }
}







