//
//  ContentView.swift
//  TheRideApp
//
//  Created by Brayhan Morrobel on 9/4/25.
//

import SwiftUI
import MapKit

//MARK: ContentView

struct ContentView: View {
    
    @State var passenger = PassengerObjects() //The creation of the passenger object
    @State var loggedIn = false //For debuggin: make to true.
   
    var body: some View{
        
        if (loggedIn == false){
            LoginPage(passenger: $passenger, loggedIn: $loggedIn)
        } else{
            HomePage(passenger: $passenger)
        }
        
    }
}
//MARK: End Contentview








//MARK: Info view
struct infoField: View {
    
    @State var title: String
    @Binding var text: String
    @State var disabledBool: Bool
    
    @FocusState var isTyping: Bool
    var body: some View{
        ZStack (alignment: .leading) {
            TextField("", text: $text).padding(.leading)
                .frame(width: 250, height: 35).focused($isTyping)
                .background(isTyping ? .blue : Color.primary, in:RoundedRectangle(cornerRadius: 8).stroke(style: StrokeStyle(lineWidth: 1)))
                .onTapGesture {
                    isTyping.toggle()
                }
                .disabled(disabledBool)
                
            
            Text(title)
                .background(
                    Color("TextFieldColor").opacity(isTyping || !text.isEmpty ? 1: 0)
                )
                .padding(.leading, 4).offset(y: isTyping || !text.isEmpty ? -18: 0)

                .foregroundStyle(isTyping ? .blue : Color.primary)
                .onTapGesture {
                    isTyping.toggle()
                }
            

                
               
        }
        .animation(.linear(duration: 0.1), value: isTyping)
        .onTapGesture {
            
        }
    }
    
}
