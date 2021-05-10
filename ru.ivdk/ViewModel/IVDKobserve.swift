//
//  IVDKobserve.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 12.01.2021.
//

import Foundation

import SwiftUI
import AVFoundation
import MapKit
struct Link {
    static let link = "https://agency78.spb.ru/ivdkapp"
}

class IVDKobserver : ObservableObject {
    
    @Published var cities = [CityView]()
    var jsonLink : URL? = URL(string: Link.link + "/data.json")
    @Published var views = [CityCell]()
    
    @Published var viewsRoutes = [[RouteCell]]()
    @Published var showVideo = false
    @Published var zoomToRoute = false
    @Published var selectedVideo : URL? = nil
    @Published var updateMap = false
    @Published var focusCity = CityView(id: 0, city: "", routesCount: "", image: "", desc: "", geo: [Double]())
    
    
    init() {
        parseJSON()
    }
    func parseJSON() {
        if let path = Bundle.main.path(forResource: "json", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let r = try JSONDecoder().decode(JSONdata.self, from: data)
            
            DispatchQueue.main.async {
                                        
            
                                        self.cities = r.city

                
                                            for i in self.cities {
                                            self.views.append(
                                                CityCell(item : i)
                                                   
                                            )
                                                
                                                self.updateMap = true
                                                if let routes =  i.routes {
                                                    
                                                    var arr = [RouteCell]()
                                                    
                                                    for routeCell in routes{
                                                        if let route = routeCell {
                                                            arr.append(RouteCell(item : route))
                                                        }
                                                    }
                                                    
                                                    self.viewsRoutes.append(arr)
                                                
                                                }
                                                
                                            }
                                        
                                    }
            }
            
            catch {
                print(error)
            }
        
        }
    }
    func loadJSON() {
        
      
        do {
            
            
            if let url = jsonLink {


                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data, !data.isEmpty else {
                        print("Error: data is nil or empty")
                        return
                    }



                let r = try? JSONDecoder().decode(JSONdata.self, from: data)

                        DispatchQueue.main.async {
                            if let result = r {

                            self.cities = result.city
                                print("result.city")

                                for i in self.cities {
                                self.views.append(
                                    CityCell(item : i)
                                        //.environmentObject(detailObject) as! CityCell
                                    
                                    
                                )
                                    self.updateMap = true
                                    if let routes =  i.routes {
                                        
                                        var arr = [RouteCell]()
                                        
                                        for routeCell in routes{
                                            if let route = routeCell {
                                                arr.append(RouteCell(item : route))
                                            }
                                        }
                                        
                                        self.viewsRoutes.append(arr)
                                    
                                    }
                                }
                            } else {
                                print("((((")
                        }

                        }
                }.resume()




            }
        } catch {
            print("error ")
        }
    }
    
//    func addLines(_ uiView : MKMapView)  {
//
//        uiView.removeOverlays(uiView.overlays)
//        for i in self.cities {
//            if i.geo.count == 2 {
//                let annotation = CityAnno(latitude: i.geo[0], longitude: i.geo[1])
//                annotation.title = i.city
//
//                if let routes = i.routes{
//                    for j in routes {
//                        if let route = j {
//
//
//                            if let points = route.points {
//
//
//                                                                var coords = [CLLocationCoordinate2D]()
//                                for p in points {
//                                    if let point = p {
//
//                                        coords.append(CLLocationCoordinate2D(latitude: point.geo[0], longitude: point.geo[1]))
//
//
//
//                                    }
//                            }
//
//                                let polyline = MKPolyline(coordinates: coords, count: coords.count)
//                                DispatchQueue.main.async {
//                                uiView.addOverlay(polyline)
//
//                                }
//
//                            }
//
//
//
//                        }
//                }
//                }
//            }
//        }
//        }
}

struct JSONdata: Decodable {
    var speaker : [Speaker]?
    var person : [Person]?
   var city : [CityView]
    
}


struct CityView: Identifiable, Hashable, Decodable {
    var id : Int
    var city: String
    var routesCount: String
    var image : String
    var desc : String
    var geo : [Double]
    var routes : [Route?]?
}

struct Route: Identifiable, Hashable, Decodable {
    
    var id : Int
    var name: String
   // var qr : String?
    var desc: String?
    var image : String?
    var color : String
    var speakerID : Int
    var underground : String?
    var video : String?
    var points : [Point?]?

}
struct Point: Identifiable, Hashable, Decodable {
    
    var id : Int
    var name: String
    var audio: String
    var images : [String]
    var address : [String]
    var geo : [Double]
    var personID : [Int]?
    var text : String

}

struct Person: Identifiable, Hashable, Decodable {
    
    var id : Int
    var name: String
    var year : String?
    var image : String?
    var text : String

}

struct Speaker: Identifiable, Hashable, Decodable {
    
    var id : Int
    var name: String
    var image : String
    var city : String
}

