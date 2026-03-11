//
//  LocationObjectsFile.swift
//  TheRideApp
//
//  Created by Brayhan Morrobel on 12/29/25.
//

import Foundation

struct LocationObjects {
    
    let id = UUID()
    var name = String()
    var latitude = Double()
    var longitude = Double ()
    
}

struct PassengerObjects {
    
    var request_id: UUID?
    var name = String ()
}
