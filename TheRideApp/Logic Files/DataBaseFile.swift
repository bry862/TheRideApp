//
//  DataBaseFile.swift
//  TheRideApp
//
//  Created by Brayhan Morrobel on 9/4/25.
//

import Foundation
import Firebase

class DataBaseManager {
    
    public let ref: DatabaseReference! = Database.database().reference()
    
    func add(_ userToAdd: String) {
        self.ref.child("Passangers").child(userToAdd).setValue(["Test": 1])    }
    
    
}
