//
//  CityAnno.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 13.01.2021.
//

import Foundation
import MapKit
import SwiftUI


class CityAnno: NSObject, MKAnnotation {

var color : String?
    var cityID : Int?
    var routeID : Int?
    var pointID : Int?

    var coordinate: CLLocationCoordinate2D
       var title: String?
       var subtitle: String?

       init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
           self.coordinate = coordinate
           self.title = title
           self.subtitle = subtitle
       }


}

class PersAnno: NSObject, MKAnnotation {

var color : String?
    var cityID : Int?
    var routeID : Int?
    var pointID : Int?
    var person : Person?

    var coordinate: CLLocationCoordinate2D
       var title: String?
       var subtitle: String?

       init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
           self.coordinate = coordinate
           self.title = title
           self.subtitle = subtitle
       }


}



class RoutePolyline: MKPolyline {
//var title: String?
//var subtitle: String?
//var latitude: Double
//var longitude:Double
var color : String?
    var cityID : Int?
    var routeID : Int?
   // var pointID : Int
   
//{
//return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//}

//    init(coordinates: [CLLocationCoordinate2D], count: Int,  cityID : Int,  routeID : Int,  color : String) {
//       // super.init(coordinates: coordinates, count: counts)
//        self.coordinates = coordinates
//    self.cityID = cityID
//    self.routeID = routeID
//    self.color = color
//        self.count = count
//}
}

class PointView: MKAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: 0) // Offset center point to animate better with marker annotations
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? CityAnno,
              let color = cluster.color
               {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
               // let count = cluster.memberAnnotations.count
canShowCallout = false
            
            
                image = renderer.image { _ in
                    
                    UIColor.init(Color.init(hex: color)).setFill()
                    UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 30, height: 30)).fill()

                   
                    let piePath = UIBezierPath()
                  
                    piePath.addLine(to: CGPoint(x: 15, y: 15))
                    piePath.close()
                    piePath.fill()

                  
                    let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                                       NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
                    let text = cluster.title ?? ""
                    let size = text.size(withAttributes: attributes)
                    let rect = CGRect(x: 15 - size.width / 2, y: 15 - size.height / 2, width: size.width, height: size.height)
                    text.draw(in: rect, withAttributes: attributes)
                }
            } else if let cluster = newValue as? PersAnno
            
                       {
                
                        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
                       // let count = cluster.memberAnnotations.count
        canShowCallout = false
                    
                    
                        image = renderer.image { _ in
                            
                            UIColor.init(Color.white).setFill()
                            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 30, height: 30)).fill()

                           
                            let piePath = UIBezierPath()
                          
                            piePath.addLine(to: CGPoint(x: 15, y: 15))
                            piePath.close()
                            piePath.fill()

                          
                            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)]
                            let text = "❓"
                            
                            let size = text.size(withAttributes: attributes)
                            let rect = CGRect(x: 15 - size.width / 2, y: 15 - size.height / 2, width: size.width, height: size.height)
                            text.draw(in: rect, withAttributes: attributes)
                        }
                    }
        }
    }

}
