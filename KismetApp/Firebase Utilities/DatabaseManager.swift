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
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        DatabaseManager.firebaseDB
            .collection(DatabaseKeys.UsersCollectionKey)
            .document(user.uid)
            .updateData(["gender" : person.gender,
                         "imageURL" : person.image,
                         "name" :   person.name,
                         "age" : person.age                                   ])
            { (error) in
        if let error = error {
            
        } else {
            print("posted person's profile")
        }
        
//        var  reference: DocumentReference? = nil
//         reference = firebaseDB.collection(DatabaseKeys.UsersCollectionKey).addDocument(data: [
//            "imageURL" : person.image,
//            "name"  : person.name,
//            "age"   : person.age,
//            "gender": person.gender,
//            ], completion: { (error) in
//                if let error = error {
//                    print("posting userinfo failed with error: \(error)")
//                } else {
//                    print("post created at ref: \(reference?.documentID ?? "no doc id")")
//
//                    DatabaseManager.firebaseDB.collection(DatabaseKeys.UsersCollectionKey)
//                    .document(reference!.documentID)
//                        .updateData([ "databaseRef": reference!.documentID], completion: { (error) in
//                            if let error = error {
//                                print("error updating field: \(error)")
//                            } else {
//                                print("field updated")
//                            }
//                        })
//                    }
//        })
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
}
