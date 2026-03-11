//
//  MapView.swift
//  TheRideApp
//
//  Created by Brayhan Morrobel on 3/10/26.
//

import SwiftUI
import CoreLocation
import MapKit
import Firebase

//MARK: MapView
struct TheMapView: UIViewRepresentable {
   
    
    
    @Binding var LocationArray: [LocationObjects]
    @Binding var PassengerCurrentLocation: MKMapItem?
    @Binding var PassengerDropOffLocation: MKMapItem?
    
    @Binding var GlobalLocationManager: LocationClass1
    
    
    @State var TargetPolyline: MKPolyline?
    @State var center = CLLocationCoordinate2D(latitude: 19.37313, longitude: -69.85623) //Nagua Coordinates
    @State var span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    
    
    //MARK: MakeUI
    func makeUIView(context: Context) -> MKMapView {
        
        let map = MKMapView()
        
        
        let region = MKCoordinateRegion(center: center, span: span)
        map.setRegion(region, animated: true)
        
        //MARK: This single line, I need to study it still.
        map.delegate = context.coordinator
        
       
        
        return map
    }


    
    //MARK: UpdateUI
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        
        //MARK: Adding the pins into the map
        if (!LocationArray.isEmpty){
            //If the array has anything at all (it does since we entered this if statement), no matter the amount, clear the old map.
            for items in uiView.annotations{
                uiView.removeAnnotation(items)
            }
            
            //Add passenger location pin
            if ((GlobalLocationManager.getAuthorizationStatus() == .authorizedWhenInUse || GlobalLocationManager.getAuthorizationStatus() == .authorizedAlways) && PassengerCurrentLocation != nil) {
                
                //We dont need to center around the users location
                
                //We must add a pin on the passengers location. It is separate from the rest of the pins on the Locations Array.
                //UPDATE: The passenger location should be treated as anothe rpin in the array.
                
                let passenger_location_point_annotation = MKPointAnnotation()
                passenger_location_point_annotation.title = "Pick Up"
                passenger_location_point_annotation.coordinate = PassengerCurrentLocation!.placemark.coordinate
                uiView.addAnnotation(passenger_location_point_annotation) //Added to map, I will now add to array
                
                
                
            }
            
           
            
            //Only one element: Manual handling
            if (LocationArray.count == 1){
                //Add the single item and center the map around it.
                uiView.addAnnotation(MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: LocationArray[0].latitude, longitude: LocationArray[0].longitude), title: LocationArray[0].name, subtitle: "None"))
                
                center.latitude = LocationArray[0].latitude; center.longitude = LocationArray[0].longitude
                
                //The line below was commented out bc I am trying to not re center the map in updateUIView
//                region.center = center; uiView.setRegion(region, animated: true) //I think re assignment is fine.
                
                
            } else if (LocationArray.count > 1) {
                

                //Loop add, and call showAnnotations
                for element in LocationArray{
                    uiView.addAnnotation(MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: element.latitude, longitude: element.longitude), title: element.name, subtitle: "None"))
                }
                
                
                
                uiView.showAnnotations(uiView.annotations, animated: true)
            }
            
            
            if (PassengerDropOffLocation != nil) {
                print ("Test 1")
                
                calculateRoute(from: PassengerCurrentLocation, to: PassengerDropOffLocation) { x in
                    if let poly = x {
                        TargetPolyline = x!
                        for line in uiView.overlays {
                            uiView.removeOverlay(line)
                        }
                        uiView.addOverlay(poly)
                        
                    }
                    
                }
            } else {
                print ("Test 2")
            }
            
        }
        

        
        
        
        
        
        
        
    }
    
    
    //MARK: Other Map Function

    
    func calculateRoute (from:MKMapItem? , to:MKMapItem?, completionHandeler: @escaping (MKPolyline?) -> Void) -> Void{
        
        let request = MKDirections.Request()
        
        let source_MapItem = MKMapItem(placemark: MKPlacemark(coordinate: PassengerCurrentLocation!.placemark.coordinate))
        source_MapItem.name = "Pick-Up"
        
        let destination_MapItem = MKMapItem (placemark: MKPlacemark(coordinate: PassengerDropOffLocation!.placemark.coordinate))
        destination_MapItem.name = "Drop-Off"
        
        request.source = source_MapItem
        request.destination = destination_MapItem
        
        let result = MKDirections(request: request)
        
        result.calculate(completionHandler: { (x: MKDirections.Response?, y: Error?) in
            
            if y != nil {
                
            }
            
            else {
                if x?.routes != nil {
                    completionHandeler (x!.routes[0].polyline)
                }
            }
            
            
        })
        
        
        
    }
    

    
    //MARK: Coordinator Class
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        func mapView( _ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            //COPY PASTED SNIPPET
            
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
