//
//  PersonModel.swift
//  KismetApp
//
//  Created by Jabeen's MacBook on 3/6/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import Foundation

struct PersonModel {
    let image: String
    let name: String
    let age: String
    let gender: String
    
    init(image: String, name: String, age: String, gender: String) {
        self.image = image
        self.name = name
        self.age = age
        self.gender = gender
    }
    init(dict: [String: Any]) {  // need a dict because firebase saves in dict
        self.image = dict["image"] as? String ?? "image does not exist"      // in my firebase here I went and made a note in racereviews of what is a key and value
        self.name = dict["name"] as? String ?? "name does not exist"
        self.age = dict["age"] as? String ?? "age does not exist"
        self.gender = dict["gender"] as? String ?? "gender does not exist"
    }
}
