//
//  ContentView.swift
//  TheRideApp
//
//  Created by Brayhan Morrobel on 9/4/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
   
    //High Value Variables
    @State var DBManager_ = DataBaseManager()
    @State var GlobalLocationManager = LocationClass1()
    @State var LocationsArray: [MKPointAnnotation] = []
    @State var PassengerCurrentLocation: CLLocation?
    @State var TargetPolyline = MKPolyline()
    @State var PassengerDropoffPointAnnotationItem = MKPointAnnotation()
    
    
    
  
    //Primative Variables
    @State var passenger_name_ = String()
    @State var passenger_destination_ = String()
    @State var size_:CGFloat = 300
    @State var passenger_location_name = "Searching..."

    
    //Work in progress
    @State var pickup = ""
    @State var dropoff = ""
    
    
    var body: some View {
        
        VStack{
     
            TheMapView(LocationArray: $LocationsArray, TargetPolyline: $TargetPolyline, PassengerCurrentLocation:  $PassengerCurrentLocation, GlobalLocationManager: $GlobalLocationManager)
                .frame(width: 350 , height: size_) // Enlarge with an animation by changing size_ on button press.
                .cornerRadius(20)
                Spacer()

            VStack{
                infoField(title: "Pickup", text: $pickup)
                HStack{
                    infoField(title: "Dropoff", text: $dropoff).padding(.leading,48)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8).fill(.blue).frame(width: 40, height: 30)
                        Button (action: {
                            LocationsArray.removeAll() //The array will be populated with new results.
                            if ( !pickup.isEmpty && !dropoff.isEmpty) {
                                PassengerCurrentLocation = GlobalLocationManager.getPassengerLocationObject()
                                
                                findLocations(near: PassengerCurrentLocation, named: dropoff)
                            
                            }
                        }) {
                            Image(systemName: "arrow.right").foregroundColor(.white)
                        }
                        
                       
                        
                        
                    }
                }
               
                
                Text("Search Results").font(.title)
                
                
                
            }.padding().position(x: 210, y: 80)
            
            
            
//            VStack {
//                Text("Pick-up").font(.footnote)
//                HStack{
//
//                    Text(passenger_location_name)
//
//
//                    Button ("Search") {
//
//                        PassengerCurrentLocation = GlobalLocationManager.getPassengerLocationObject()
//
//                        GlobalLocationManager.callReverseGeocode({ (x: [CLPlacemark]?, y:Error?) in
//                            if y != nil {
//                                print ("Geocode error")
//                            }
//
//                            else if let geocode_result_name = x!.first!.name {
//                                passenger_location_name = geocode_result_name
//                            }
//
//
//                        })
//                    }
//                    .buttonStyle(.bordered)
//
//
//
//
//                }
//
//                Text("Drop-ff").font(.footnote)
//                HStack {
//                    TextField("Type a drop-off location", text: $passenger_destination_)
//                    Button ("Go"){
//                        findLocations(near: PassengerCurrentLocation, named: passenger_destination_)
//
//
//                    }.buttonStyle(.bordered)
//                }
//
//
//
//
//
//
//
//                Spacer()
////                Button ( action: {
////                    findLocation(named: passenger_destination_)
////                    size_ = 500
////
////
////
////                }) {
////                    Image(systemName: "personalhotspot.circle.fill")
////                }
////
////                Button (action: {
////
////                    calculateRoute(LocationsArray, completionHandeler: { (x: MKPolyline?) in
////                        TargetPolyline = x!
////                    })
////
////
////
////                    //This check is to ensure the previous button was handed the tools to do its task
////                    the_temporary_messege = "Index 0: \(LocationsArray[0].coordinate.latitude) and Index 1: \(LocationsArray[1].coordinate.latitude)"
////                }) {
////                    Image(systemName: "map")
////                }
////
////                Text (the_temporary_messege)
////
//
//
//
//            }
            
        }
    }
    
    
    func compare (_ coordinate_in_question: CLLocationCoordinate2D, withRefferenceTo: CLLocation) -> Bool {
        let ReigonN: [String:(Double, Double)] = [
            
            
            "a": (withRefferenceTo.coordinate.latitude + 0.2, withRefferenceTo.coordinate.longitude - 0.2),
            "b": (withRefferenceTo.coordinate.latitude - 0.2, withRefferenceTo.coordinate.longitude + 0.2)
        ]
        
        // latitude: 19.37313, longitude: -69.85623
        
        
        //Condition 1, phi
        if ((coordinate_in_question.latitude <= ReigonN["a"]!.0) && (coordinate_in_question.latitude >= ReigonN["b"]!.0)){
            
            //Condition 2, lamda
            if ((coordinate_in_question.longitude >= ReigonN["a"]!.1) && (coordinate_in_question.longitude <= ReigonN["b"]!.1)) {
                return true
            }
    
        }
        
        return false
    }
    
    func findLocations (near user_current_location: CLLocation?,named target_location: String) -> Void {
        
        
        if LocationsArray.isEmpty {
            print ("Emptied out the array")
        }else {
            print ("error clearing")
        }
        
        let request = MKLocalSearch.Request()
        
        var center = CLLocationCoordinate2D()
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        
        if (user_current_location != nil){
            center.latitude = user_current_location!.coordinate.latitude
            center.longitude = user_current_location!.coordinate.longitude
            
        } else {
            print ("Error with user_current_location in findLocations")
            return
        }
        let region = MKCoordinateRegion(center: center, span: span)
        
        request.region = region
        request.naturalLanguageQuery = target_location
        request.resultTypes = .pointOfInterest
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: { (result: MKLocalSearch.Response?, errorMessage: Error?) in
            if errorMessage != nil {
                print ("Error Searching")
                return
            }
            
            for item in result!.mapItems {
                
                if (compare(item.placemark.coordinate, withRefferenceTo: user_current_location!)) {
                    let newAnotation = MKPointAnnotation()
                    newAnotation.coordinate = item.placemark.coordinate
                    newAnotation.title = item.name
                    
                   
                    LocationsArray.append(newAnotation)
                
                }else {
                    print ("Not Added")
                }
            }
        })
      
    }
    
    func calculateRoute (_ LocationsArray: [MKPointAnnotation], completionHandeler: @escaping (MKPolyline?) -> Void) -> Void {
        
        //I pass the entire array bc by the time this function is called,the array
        //will have [0] -> Start and [1]-> destination only. Even if it has more than 2,
        //this should still work as intended as long as both indecies are different.
        let directions_ = MKDirections.Request()
        
        //First we need to make the MapItems from the array
        let source_MapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: LocationsArray[0].coordinate.latitude, longitude: LocationsArray[0].coordinate.longitude)))
        
        let destination_MapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: LocationsArray[3].coordinate.latitude, longitude: LocationsArray[3].coordinate.longitude)))
        
        source_MapItem.name = "Pick-up location"
        destination_MapItem.name = "Drop-off Location"
        
        
        directions_.source = source_MapItem
        directions_.destination = destination_MapItem
        
        let result_ = MKDirections(request: directions_)
//        var route_result = MKPolyline() //The route. I will default to the first route in the Response array
        
        result_.calculate(completionHandler: { (x:MKDirections.Response?, y:Error?) in
        
            if (y != nil){
                
            }
            
            else {
                if x?.routes != nil{
                    
                    
                    completionHandeler(x!.routes[0].polyline)
                }
            }
            
            
        })
        
        
        
        
    }
    
       
    }
   
struct TheMapView: UIViewRepresentable {
   
    
    
    @Binding var LocationArray: [MKPointAnnotation]
    @Binding var TargetPolyline: MKPolyline
    @Binding var PassengerCurrentLocation: CLLocation?
    @Binding var GlobalLocationManager: LocationClass1
    
    func makeUIView(context: Context) -> MKMapView {
        
        let map = MKMapView()
        
        let center = CLLocationCoordinate2D(latitude: 19.37313, longitude: -69.85623) //Nagua Coordinates
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: center, span: span)
        map.setRegion(region, animated: true)
        
        //MARK: This single line, I need to study it still.
        map.delegate = context.coordinator
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        
        var center = CLLocationCoordinate2D()
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)

        //Centering the map
        if ((GlobalLocationManager.getAuthorizationStatus() == .authorizedWhenInUse || GlobalLocationManager.getAuthorizationStatus() == .authorizedAlways) && PassengerCurrentLocation != nil) {
            
            center.latitude = PassengerCurrentLocation!.coordinate.latitude
            center.longitude = PassengerCurrentLocation!.coordinate.longitude
            
            //We must add a pin on the passengers location. It is separate from the rest of the pins on the Locations Array.
            let passenger_location_point_annotation = MKPointAnnotation()
            passenger_location_point_annotation.title = "Pick Up"
            passenger_location_point_annotation.coordinate = PassengerCurrentLocation!.coordinate
            uiView.addAnnotation(passenger_location_point_annotation)
            
        } else {
            
            //Our default location.
            center.latitude =  19.37313
            center.longitude = -69.85623
            
        }
        var region = MKCoordinateRegion(center: center, span: span)
        uiView.setRegion(region, animated: true)
        
        //MARK: Adding the pins into the map
        if (!LocationArray.isEmpty){
            //If the array has anything at all (it does since we entered this if statement), no matter the amount, clear the old map.
            for items in uiView.annotations{
                uiView.removeAnnotation(items)
            }
            //Only one element: Manual handling
            if (LocationArray.count == 1){
                //Add the single item and center the map around it.
                uiView.addAnnotation(LocationArray[0])
                
                center.latitude = LocationArray[0].coordinate.latitude; center.longitude = LocationArray[0].coordinate.longitude
                region.center = center; uiView.setRegion(region, animated: true) //I think re assignment is fine.
                
                
            } else if (LocationArray.count > 1) {
                //Loop add, and call showAnnotations
                for elements in LocationArray{
                    uiView.addAnnotation(elements)
                }
                
                
                
                uiView.showAnnotations(uiView.annotations, animated: true)
            }
            
        }
        
        
        uiView.addOverlay(TargetPolyline)
        
        
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    class Coordinator: NSObject, MKMapViewDelegate {
        
        func mapView( _ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            //COPY PASTE SNIPPET
            
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
}

struct infoField: View {
    
    @State var title: String
    @Binding var text: String
    @FocusState var isTyping: Bool
    var body: some View{
        ZStack (alignment: .leading) {
            TextField("", text: $text).padding(.leading)
                .frame(width: 250, height: 35).focused($isTyping)
                .background(isTyping ? .blue : Color.primary, in:RoundedRectangle(cornerRadius: 8).stroke(style: StrokeStyle(lineWidth: 1)))
                .onTapGesture {
                    isTyping.toggle()
                }
                
            
            Text(title)
                .background(
                    Color("TextFieldColor").opacity(isTyping || !text.isEmpty ? 1: 0)
                )
                .padding(.leading, 4).offset(y: isTyping || !text.isEmpty ? -18: 0)

                .foregroundStyle(isTyping ? .blue : Color.primary)

                
               
        }
        .animation(.linear(duration: 0.1), value: isTyping)
    }
    
}
