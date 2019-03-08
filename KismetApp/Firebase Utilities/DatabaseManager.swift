//
//  DatabaseManager.swift
//  KismetApp
//
//  Created by Jabeen's MacBook on 3/6/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class DatabaseManager {
    private init() {}
    
    static let firebaseDB: Firestore = {
        // gets a reference to firestore database
        let db = Firestore.firestore()
        let settings = db.settings
        db.settings = settings
        
        return db
    }()

    static func postPersonProfileToDatabase(person: PersonModel) {
         firebaseDB.collection(DatabaseKeys.UsersCollectionKey).addDocument(data: [
            "image" : person.image,
            "name"  : person.name,
            "age"   : person.age,
            "gender": person.gender,
            ], completion: { (error) in
                if let error = error {
                    print("posing race failed with error: \(error)")
            }
        })
    }
}


// in firebase we do this in our database which allows our authorized users to write to our database
// Allow read/write access on all documents to any user signed in to the application
//service cloud.firestore {
//    match /databases/{database}/documents {
//        match /{document=**} {
//            allow read, write: if request.auth.uid != null;
//        }
//    }
//}
