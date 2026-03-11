//
//  DataBaseFile.swift
//  TheDriverApp
//
//  Created by Brayhan Morrobel on 1/1/26.
//

import Foundation
import Firebase

class DataBaseClass {
    
   

    
    //Initialiation
    
    static let shared = DataBaseClass()
    
    public let ref: DatabaseReference! = Database.database().reference()
    
    
    
}
