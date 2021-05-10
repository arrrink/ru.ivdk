//
//  MapView.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 07.01.2021.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

//import Firebase

//import GoogleMaps
//import GooglePlaces




struct MapView : UIViewRepresentable {
   
    var lastLocation = CLLocation(latitude: 55.753215, longitude: 37.622504).coordinate
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool
    @Binding var show : Bool
//    @EnvironmentObject var data : IVDKobserve
    @EnvironmentObject var playerOdserve : PlayerOdserve
//    @Binding var showObjectDetails : Bool
//
//    @EnvironmentObject var getObjects : getTaFlatPlansData
//
//    @Binding var complexNameArray: [CustomAnnotation]
//
//    @Binding var tappedComplexName: CustomAnnotation

    let map = MKMapView()
    
    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(parent1: self)
    }
   
  
   
     func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        manager.delegate = context.coordinator
       let center = lastLocation
       let region = MKCoordinateRegion(center: center, latitudinalMeters: 5000, longitudinalMeters: 5000)
//
        let anno = CityAnno(coordinate: CLLocationCoordinate2D(latitude: lastLocation.latitude, longitude: lastLocation.longitude), title: "", subtitle: "")
        
        map.zoomToFit(annotations: [anno], distance: 1000)

        map.region = region
        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
       // let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.tap(ges:)))
         //       map.addGestureRecognizer(gesture)
//        map.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
//        map.register(CustomAnnotationView.self,
//                               forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//
        map.register(PointView.self,
                               forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        map.showsUserLocation = true
       
            map.translatesAutoresizingMaskIntoConstraints = false

        map.userLocation.title = ""
    
        map.delegate = context.coordinator
    
//        DispatchQueue.main.async {
//
//
//
//            map.addAnnotations(complexNameArray)
//
//
//    }
          
      
        
        
        
        return map
    }
    
    func zoomToRoute(_ view : MKMapView)  {
        guard let p = self.playerOdserve.selectedRoute.points  else {
            return
        }
        
        var coords = [MKAnnotation]()
        for i in p {
            
            if let point = i {
                
               
                let anno = CityAnno(coordinate: CLLocationCoordinate2D(latitude: point.geo[0], longitude: point.geo[1]), title: "\(point.id)", subtitle: "")
                
                anno.color = self.playerOdserve.selectedRoute.color
                
   
                                               
                coords.append(anno)
            
                
               

            }
            
        }
        DispatchQueue.main.async {
            view.zoomToFit(annotations: coords , distance: 500)
        }
        
        
    }
    
   
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        
        if self.playerOdserve.zoomToRoute {
            zoomToRoute(uiView)
            self.playerOdserve.zoomToRoute.toggle()
        }
        
        if self.playerOdserve.updateMap {
          
            self.playerOdserve.addLines(uiView)
            
            
            
            
            if let focusCity = playerOdserve.cities.firstIndex(of: playerOdserve.focusCity)
            {
               
                let city = playerOdserve.cities[focusCity]
                // let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: data.cities[focusCity].geo[0], longitude: data.cities[focusCity].geo[1]), span: uiView.region.span)
                
                

               // uiView.setRegion(region, animated: false)
                let anno = CityAnno(coordinate: CLLocationCoordinate2D(latitude: city.geo[0], longitude: city.geo[1]), title: "", subtitle: "")

               // let a = uiView.annotations.filter({$0.title == data.cities[focusCity].city})
                DispatchQueue.main.async {


                uiView.zoomToFit(annotations: [anno] , distance: 1000)
                }
                
            }
            
        
//        uiView.removeAnnotations(uiView.annotations)
//        for i in data.cities {
//            if i.geo.count == 2 {
//                let annotation = CityAnno(latitude: i.geo[0], longitude: i.geo[1])
//                annotation.title = i.city
//                DispatchQueue.main.async {
//
//                    uiView.addAnnotation(annotation)
//                }
//            }
//        }
            playerOdserve.updateMap.toggle()
        }
        if self.show {
            DispatchQueue.main.async {
                
                uiView.layoutIfNeeded()
        uiView.layoutSubviews()
            }
        }
//        if tappedComplexName.title != nil && getObjects.needSetRegion {
//
//            uiView.region = MKCoordinateRegion(center: tappedComplexName.coordinate, span: uiView.region.span )
//
//            getObjects.needSetRegion.toggle()
//
//
//
//        }
//        if getObjects.showCurrentLocation {
//
//            guard manager.location != nil else {
//                getObjects.showCurrentLocation.toggle()
//                return
//            }
//
//            let region = MKCoordinateRegion(center: manager.location!.coordinate, span: uiView.region.span)
//
//            uiView.setRegion(region, animated: false)
//            getObjects.showCurrentLocation.toggle()
//        }
//        if getObjects.needUpdateMap {
//        uiView.removeAnnotations(uiView.annotations)
//
//            DispatchQueue.main.async {
//
//
//
//                uiView.addAnnotations(complexNameArray)
//
//
//        }
//            getObjects.needUpdateMap.toggle()
//        }
        
        
          
    }
    
    class Coordinator : NSObject,CLLocationManagerDelegate, MKMapViewDelegate {
        
         var isFirst = true
        
        var parent : MapView
        
         var annotationView =  MKPinAnnotationView()
        
        init(parent1 : MapView) {
            
            parent = parent1
            
            
            
            // MARK: map custom style
            
//           //  We first need to have the path of the overlay configuration JSON
//            guard let overlayFileURLString = Bundle.main.path(forResource: UITraitCollection.current.userInterfaceStyle == .dark ? "darkoverlay" : "overlay", ofType: "json") else {
//                    print("not f")
//                           return
//                   }
//                   let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
//
//                   // After that, you can create the tile overlay using MapKitGoogleStyler
//                   guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
//                    print("not build")
//                       return
//                   }
//
//    //                And finally add it to your MKMapView
//            parent.map.addOverlay(tileOverlay)
//
//
           
     
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard view.annotation != nil else {
                return
            }
            guard !view.annotation!.isKind(of: MKUserLocation.self)

            else {
               
                return
            }
            guard !view.annotation!.isKind(of: MKClusterAnnotation.self) else {return}
            
            guard let anno = view.annotation! as? CityAnno,
                  let city = anno.cityID,
                  let route = anno.routeID,
                  let point = anno.pointID
                  else {
               
                return}
            let d = self.parent.playerOdserve
            DispatchQueue.main.async {

                d.selectedCity = d.cities[city - 1]
            
                d.showCityRoutes = true
                
                if let r = d.selectedCity.routes,
                   let rID = r[route - 1],
                   let points = rID.points,
                   
                   point <= points.count,
                   point > 0,
                   let p = points[point - 1]
                   {
                    
                    d.selectedRoute = rID
                    
                    d.showRoute = true
                    
                    d.fromMap = true
                  //  d.currentPoint = CurrentPoint(cityID: d.selectedCity.id, routeID: d.selectedRoute.id, point: p)
                   
                  //  d.tapAudio(p)
                    d.showPlayer = true
                    
                    d.changePoint(cP: CurrentPoint(cityID: d.selectedCity.id, routeID: d.selectedRoute.id, point: p))
                  
                   
                }
                    
              //  }
                
            }
//            if let title = view.annotation?.title! {
//                self.parent.getObjects.tappedObjectComplexName = title
//
//                if view.annotation?.coordinate != nil {
//                    let center = view.annotation?.coordinate
//
//                    mapView.setRegion(MKCoordinateRegion(center: center!, span: self.parent.map.region.span ), animated: true)
//                }
//                self.parent.showObjectDetails = true
//
//
//
//                if self.parent.getObjects.tappedObjectComplexName != "" {
//                    let filter = self.parent.getObjects.objects.filter{$0.complexName == self.parent.getObjects.tappedObjectComplexName}
//
//                    self.parent.getObjects.tappedObject = filter[0]
//
//
//                }
//
//
//            }
            
            self.parent.map.deselectAnnotation(view.annotation, animated: true)
            
            
        }
        
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
        


                if let tileOverlay = overlay as? RoutePolyline,
                   let color = tileOverlay.color{

                    let over = MKPolylineRenderer(overlay: tileOverlay)
                    over.strokeColor = UIColor(Color.init(hex: color))
                    over.lineWidth = 3
                    return over

                }
                else {
                    let over =  MKPolylineRenderer(overlay: overlay)
                    over.strokeColor = .red
                    over.lineWidth = 3
                    return over

                }
         
        }
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            if status == .denied{
                
                parent.alert.toggle()
                
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let location = locations.last?.coordinate ?? self.parent.lastLocation
           
         
                if self.isFirst {
                    
                    if location.latitude > 59.117790 && location.longitude > 28.088136
                        && location.longitude < 35.937759 && location.latitude < 61.124369 {
                    
                    let region = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
                                   self.parent.map.region = region
                    } else {
                       let region = MKCoordinateRegion(center: self.parent.lastLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
                                       self.parent.map.region = region
                    }
                    
                    self.isFirst.toggle()
                }
        }
    }
   
  
    
    /// The map view asks `mapView(_:viewFor:)` for an appropiate annotation view for a specific annotation.
    /// - Tag: CreateAnnotationViews
    
 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        
        let annotationView = MKAnnotationView()
        
        
       
//      if let annotation = annotation as? CustomAnnotation {
//
//            annotationView = setupCustomAnnotationView(for: annotation, on: mapView)
//         //   annotationView?.displayPriority = .required
//
//        } else if let annotation = annotation as? MKClusterAnnotation {
//            annotationView?.displayPriority = .required
//
//
//
//        }
        
        
       

        
        return annotationView
    }
        
//        private func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
//            return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotation.self), for: annotation)
//        }
    
//    private func setupClusterAnnotationView(for annotation: MKClusterAnnotation, on mapView: MKMapView) -> MKAnnotationView {
//
//
//               return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation)
//           }

}

