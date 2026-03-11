//
//  DataBaseFile.swift
//  TheRideApp
//
//  Created by Brayhan Morrobel on 9/4/25.
//

import Foundation
import Firebase
import CoreLocation
import MapKit

class DataBaseManager {
    
    var requestCount = 1
    
    static let shared = DataBaseManager() //Allows the class itslef to be the class object
    
    public let ref: DatabaseReference! = Database.database().reference()
    
    
    //I wont use as of now. 
//    func add(user userToAdd: PassengerObjects) {
//        
//        self.ref.child("Passengers").child(userToAdd.name).child("ID").setValue(userToAdd.id.uuidString)
//    }
    
    /*
     @brief: Function that makes a request for a user form a place to another, by creating an ID. We return that ID
     for tracking purposes.
     */
    
    func addRequest (forUser: PassengerObjects, from: MKMapItem , to: MKMapItem) -> UUID {
       
        //Request and its id
        let requestID = UUID() // I must use UUID and not .description because Im not allowed to make a UUID.description in the passenger object struct.
        
        
        self.ref.child("Request").child(requestID.description).child("Request ID").setValue(requestID.description)
    
        //Requesting Passanger name
        self.ref.child("Request").child(requestID.description).child("Passenger Name").setValue(forUser.name)
        
        //Pick up details
        self.ref.child("Request").child(requestID.description).child("Pick up").child("Latitude").setValue(from.placemark.coordinate.latitude)
        
        self.ref.child("Request").child(requestID.description).child("Pick up location").setValue(from.name)
        
        self.ref.child("Request").child(requestID.description).child("Pick up").child("Longitude").setValue(from.placemark.coordinate.longitude)
        
        //drop off details
        self.ref.child("Request").child(requestID.description).child("Drop off").child("Lattitude").setValue(to.placemark.coordinate.latitude)
        
        self.ref.child("Request").child(requestID.description).child("Drop off location").setValue(to.name)
        
        print ("Within DB file: \(to.name!)")
        
        self.ref.child("Request").child(requestID.description).child("Drop off").child("Longitude").setValue(to.placemark.coordinate.longitude)
        
        //Request Status
        self.ref.child("Request").child(requestID.description).child("Request Information").child("Current Status").setValue(false)
        requestCount+=1
        
        
        return requestID
        
        
        
     
        
        
    }
    
    
}
