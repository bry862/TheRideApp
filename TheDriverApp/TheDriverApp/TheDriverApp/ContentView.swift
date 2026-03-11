//
//  ContentView.swift
//  TheDriverApp
//
//  Created by Brayhan Morrobel on 12/31/25.
//

import SwiftUI


struct ContentView: View {
    
    @State var driver = driverObject()
    @State var loggedin = false
    
    
    var body: some View {
        
        if (!loggedin){
            LoginPage(driver: $driver, loggedin: $loggedin)
        } else {
            HomePage(driver: $driver)
        }
        
        
    }
}

