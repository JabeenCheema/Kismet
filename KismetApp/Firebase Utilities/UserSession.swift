//
//  UserSession.swift
//  KismetApp
//
//  Created by Jabeen's MacBook on 2/27/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserSessionAccountCreationDelegate: AnyObject {
    func didCreateAccount(_ userSession: UserSession, user: User)
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error)
}

protocol UserSessionSignInDelegate: AnyObject {
    func didRecieveSignInError(_ usersession: UserSession, error: Error)
    func didSignInExistingUser(_ usersession: UserSession, user: User)
}

protocol UserSessionSignOutDelegate: AnyObject {
    func didRecieveSignOutError(_ usersession: UserSession, error: Error)
    func didSignOutUser(_ usersession: UserSession)
}


final class UserSession {
    weak var userSessionAccountDelegate: UserSessionAccountCreationDelegate?
    weak var usersessionSignInDelegate: UserSessionSignInDelegate?
    weak var usersessionSignOutDelegate: UserSessionSignOutDelegate?
    
    // creates an authenticated user
    public func createNewAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.userSessionAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            } else if let authDataResult = authDataResult {
                self.userSessionAccountDelegate?.didCreateAccount(self, user: authDataResult.user)
            }
        }
    }
    
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    public func signInExistingUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.usersessionSignInDelegate?.didRecieveSignInError(self, error: error)
            } else if let authDataResult = authDataResult {
                self.usersessionSignInDelegate?.didSignInExistingUser(self, user: authDataResult.user)
            }
        }
    }
    
    public func updateExistingUserInfo(image: URL?, displayName: String, age: Int, gender: String) {
        guard let user = getCurrentUser() else {
            print("no logged user")
            return
        }
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        request.photoURL = image
        request.commitChanges { (error) in
            if let error = error {
                print("error: \(error)")
            } else {
                // update database user as well
                 guard let photoURL = image else {
                    print("no image")
                    return
                }
                DatabaseManager.firebaseDB
                    .collection(DatabaseKeys.UsersCollectionKey)
                    .document(user.uid) // making the user document id the same as the auth userId makes it easy to update the user doc
                    .updateData(["imageURL": photoURL.absoluteString], completion: { (error) in
                        guard let error = error else {
                            print("successfully ")
                            return
                        }
                        print("updating photo url error: \(error.localizedDescription)")
                        
                    })
            }
        }
    }
    public func signOut() {
        guard let _ = getCurrentUser() else {
            print("no logged user")
            return
        }
        do {
            try Auth.auth().signOut()
            usersessionSignOutDelegate?.didSignOutUser(self)
        } catch {
            usersessionSignOutDelegate?.didRecieveSignOutError(self, error: error)
        }
    }
}
