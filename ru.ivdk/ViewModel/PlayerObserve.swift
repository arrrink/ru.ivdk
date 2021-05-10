//
//  PlayerObserve.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 18.01.2021.
//

import SwiftUI
import MapKit
import AVKit
import SwiftUIPager
import SDWebImageSwiftUI
import Combine
import AVFoundation
import MediaPlayer
//class Comand : ObservableObject {
//    @Published var comand = "play"
//}
class PlayerOdserve: ObservableObject {

    @Published var selectedCity = CityView(id: 0, city: "", routesCount: "1 маршрут", image: "moscow", desc: "", geo: [0.0])
    
    @Published var selectedRoute = Route(id: 0, name: "", desc: "", image: "", color: "", speakerID: 1, underground: "", video: "", points: [Point]())
    
    @Published var currentPoint : CurrentPoint? = nil
    @Published var dinamicHeight = UIScreen.main.bounds.height / 2.5
    @Published var showCityRoutes = false
    @Published var showRoute = false
    @Published var routeMetadata : NowPlayableStaticMetadata? = nil
    @Published var dinamicHeightRouteCar : CGFloat = 350
    @Published var player = AVQueuePlayer()
    
    @Published var showPlayer = false

    @Published var routeID : Int = 0
    
    @Published var fromMap = false
    
    @Published var cT = ""
    
    
    @Published var isPlay = false
    @Published var assetPlayer : AssetPlayer!
    
    @Published var carouselLocationCity = 0
    @Published var carouselLocationRoute = 0
   // @Published var mp : MPRemoteComman

    
   // @Published var currentStatus: MPRemoteCommandCenter.KeyValueObservingPublisher
       // private var itemObservation: AnyP
    
    
    
 @Published var offset : CGFloat = 0
    
    
    //ivdkobs
    
    @Published var cities = [CityView]()
    
    @Published var person = [Person]()
    
    
    var jsonLink : URL? = URL(string: Link.link + "/data.json")
    @Published var views = [CityCell]()
    
    @Published var viewsRoutes = [[RouteCell]]()
    @Published var showVideo = false
    @Published var zoomToRoute = false
    @Published var selectedVideo : URL? = nil
    @Published var updateMap = false
    @Published var focusCity = CityView(id: 0, city: "", routesCount: "", image: "", desc: "", geo: [Double]())
    @Published var safeArea = UIApplication.shared.windows.last?.safeAreaInsets
    
    init() {
        loadJSON()
    }
    func parseJSON() {
        if let path = Bundle.main.path(forResource: "json", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let r = try JSONDecoder().decode(JSONdata.self, from: data)
            
            DispatchQueue.main.async {
                                        
            
                                        self.cities = r.city
                
                self.person = r.person ?? [Person]()

                
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
                            if let result = r,
                               let p = result.person {
                                
                                
                                self.person = p
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
    
    
    func prevPoint() {
        guard self.assetPlayer != nil,
              let cP = self.currentPoint,
              let r = self.cities[cP.cityID - 1].routes?[cP.routeID - 1],
              
            cP.point.id > 1,
              let nextPoint = r.points?[cP.point.id - 2] else {
           // self.playerOdserve.optOut()
            
            return }
              
                    
          //  print("new route")
          //  self.optOut()
            
            self.configRoute(p: nextPoint) {
                
                guard let a = self.routeMetadata else {return}
                if ConfigModel.shared == nil {

                    DispatchQueue.main.async {
                    self.currentPoint = CurrentPoint(cityID: cP.cityID, routeID: cP.routeID, point: nextPoint)
                    }
                ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior(), route: [a])
                    
                } else {
                
                
               
              
                   
                    DispatchQueue.main.async {
                        self.assetPlayer.changeTrackTo(a)
                    
                    self.currentPoint = CurrentPoint(cityID: cP.cityID, routeID: cP.routeID, point: nextPoint)
                    }
                    
                }
                
            }
            
    }
    
    func changePoint(cP : CurrentPoint) {
        
//        let a = AVQueuePlayer(playerItem: AVPlayerItem(asset: AVAsset(url: URL(string: Link.link + cP.point.audio)!), automaticallyLoadedAssetKeys: ["availableMediaCharacteristicsWithMediaSelectionOptions"]))
//
//        a.play()
//    print("h")
////
        
//        guard self.assetPlayer != nil   else {
//            self.optOut()
//
//            return}
        
        DispatchQueue.main.async {
        
        
        
              
                    
                    
                    if self.currentPoint == nil {
                    withAnimation(.spring()) {

                        self.offset += 73 + (self.safeArea?.top ?? 0.0)

                        self.dinamicHeight -= 15 + (self.safeArea?.bottom ?? 0.0)

                        self.dinamicHeightRouteCar -= 73 + (self.safeArea?.bottom ?? 0.0)

                    }
                    }
            
            
            let isCurrentPoint : Bool
            
                if cP == self.currentPoint {
                isCurrentPoint = true
            } else {
                isCurrentPoint = false
               
            }
                    
                    
                if isCurrentPoint {
                    self.playPause()
                } else if isCurrentPoint == false {
                    
                   
                    
                    self.configRoute(p: cP.point) {
                       
                            guard let a = self.routeMetadata else {return}
                       
                      //  self.optOut()
                       // ConfigModel.shared = nil
                            if ConfigModel.shared == nil {
                              //  print("next")
                                print("here")
                               
                                
                                
                               // self.optOut()
                            ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior(), route: [a])
                                
                                
                                self.optIn()
                                
                            //   self.assetPlayer.nowPlayableBehavior.setNowPlayingMetadata(a)
                                
//                                self.assetPlayer.play()
//                                self.assetPlayer.playerState = .playing
                                
                                     self.assetPlayer.changeTrackTo(a)
                                
                                self.currentPoint = cP
                                
                            } else {
                                self.assetPlayer.changeTrackTo(a)
                           
                           self.currentPoint = cP
                           
                            }
                                //else {
//
//                                if self.assetPlayer != nil {
//                                    self.currentPoint = cP
//                                self.assetPlayer.changeTrackTo(a)
//
//                                }
//                            }
                            
                       // self.assetPlayer.play()
                            
                    }
                        }

                   
                                                 
                    
               
                }
            
            
            
            
            
    }
    
    func nextPoint() {
        guard self.assetPlayer != nil,
              let cP = self.currentPoint,
              let r = self.cities[cP.cityID - 1].routes?[cP.routeID - 1],
              let p = r.points,
              p.count > 0,

              let nextPoint = r.points?[p.count > cP.point.id ? cP.point.id : 0] else {
            self.optOut()
            
            return}
              
                    
          //  print("new routenextPoint")
          //  self.optOut()
            
            self.configRoute(p: nextPoint) {
                
                guard let a = self.routeMetadata else {return}
                if ConfigModel.shared == nil {
                   // print("next")

                    DispatchQueue.main.async {


                    
                    
                ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior(), route: [a])
                    self.assetPlayer.changeTrackTo(a)
                        
                        self.currentPoint = CurrentPoint(cityID: cP.cityID, routeID: cP.routeID, point: nextPoint)
                        
                    }

                } else
                {
                
                
               
                    if self.assetPlayer != nil {
                    self.assetPlayer.changeTrackTo(a)
                    DispatchQueue.main.async {
                        
                    
                    self.currentPoint = CurrentPoint(cityID: cP.cityID, routeID: cP.routeID, point: nextPoint)
                    }
                    }
                }
            }
            
    }
    
//    func tapAudio(_ i : Point) {
//
//
//        let isCurrentPoint : Bool
//
//        if CurrentPoint(cityID: selectedCity.id, routeID: selectedRoute.id, point: i) == currentPoint {
//            isCurrentPoint = true
//        } else {
//            isCurrentPoint = false
//        }
//
//
//                DispatchQueue.main.async {
//
//
////                    if self.currentPoint == nil {
////                    withAnimation(.spring()) {
////                        self.dinamicHeight -= 73 + (self.safeArea?.bottom ?? 0.0)
////
////                        self.dinamicHeightRouteCar -= 73 + (self.safeArea?.bottom ?? 0.0)
////
////                        self.offset += 73 + (self.safeArea?.top ?? 0.0)
////                    }
////                    }
//
//
//                if isCurrentPoint {
//                    self.playPause()
//                } else {
//
//
//
//
//                    if !(self.selectedRoute.id == self.currentPoint?.routeID &&
//
//                            self.selectedCity.id   ==  self.currentPoint?.cityID)   {
//
//                        print("new route")
//                      //  self.optOut()
//
//                        self.configRoute(p: i) {
//
//                            guard let a = self.routeMetadata else {return}
//
//                            if ConfigModel.shared == nil {
//                            ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior(), route: [a])
//                            }
//
//                                self.optIn()
//
//                                self.assetPlayer.changeTrackTo(a)
//
//                        }
//
//
//
//
//                    } else {
//
//
//                        guard self.assetPlayer != nil else {
//                            print("change track [i] nil")
//                            return }
//                        self.configRoute(p: i) {
//
//                            guard let a = self.routeMetadata else {return}
//                            if ConfigModel.shared == nil {
//                            ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior(), route: [a])
//                                //self.optIn()
//                            }
//                            self.optIn()
//                            self.assetPlayer.changeTrackTo(a)
//                        }
//
//                    }
//
//
//                    self.currentPoint = CurrentPoint(cityID: self.selectedCity.id, routeID: self.selectedRoute.id, point: i)
//
//
//
//                }
//            }
//
//
//
//
//
//
//    }
    
    func addLines(_ uiView : MKMapView)  {
        
        uiView.removeOverlays(uiView.overlays)
        for i in self.cities {
            if i.geo.count == 2 {
                
                //                let annotation = CityAnno(latitude: i.geo[0], longitude: i.geo[1])
//                annotation.title = i.city

                if let routes = i.routes{
                    for j in routes {
                        if let route = j {
                            
                            
                            if let points = route.points {
                                
                                
                                var coords = [CLLocationCoordinate2D]()
                                
                                for p in points {
                                    if let point = p {
                                        let coord = CLLocationCoordinate2D(latitude: point.geo[0], longitude: point.geo[1])
                                        coords.append(coord)
                                       
                                        let anno = CityAnno(coordinate: coord, title: "\(point.id)", subtitle: "")
                                        anno.color = route.color
                                        anno.routeID = route.id
                                        anno.cityID = i.id
                                        anno.pointID = point.id
                                    
                                        DispatchQueue.main.async {
                                            uiView.addAnnotation(anno)
                                           //   print("hijjj")
                                        }
                                        

                                        
//
//                                        if let p = point.personID,
//                                            p.count > 0,
//                                            self.person.filter({$0.id == p[0]}).count > 0 {
//                                         let pI = self.person.filter({$0.id == p[0]})[0]
//
//
//
//                                         let annoPerc = PersAnno(coordinate: CLLocationCoordinate2D(latitude: point.geo[0] - randomCoordinate(), longitude: point.geo[1]  + randomCoordinate()),
//                                                                 title: "", subtitle: "")
//
//                                         annoPerc.color = route.color
//
//                                            annoPerc.person = pI
//
//                                            DispatchQueue.main.async {
//                                                uiView.addAnnotation(annoPerc)
//
//                                            }
//
//                                        }
                                        

                                        
                                    }
                            }
                                
                                let polyline = RoutePolyline(coordinates: coords, count: coords.count)
                                polyline.cityID = i.id
                                polyline.routeID = route.id
                                polyline.color = route.color
                                
                                
                                //MKPolyline(coordinates: coords, count: coords.count)
                                DispatchQueue.main.async {
                                uiView.addOverlay(polyline)
                                }

                            }
                            
                            
                            
                        }
                }
                }
            }
        }
        }
    
    //ivdkobs end
    func randomCoordinate() -> Double {
    return Double(arc4random_uniform(140)) * 0.000003
            }

    func getRoutesAssets(p: Point, completion: @escaping ( NowPlayableStaticMetadata) -> Void) {
        
        
       // var routeAsset : NowPlayableStaticMetadata
        
       

//        if let r = route.points {
//
//            var count = r.count
//
//
//            r.forEach { (point) in
                
                
                
               
                if let urlAudio = URL(string: Link.link + p.audio),
                   p.images.count != 0,
                   let urlImg = URL(string: Link.link + p.images[0]),
                   
                   p.address.count != 0
                   {

                   
                    
                    URLSession.shared.dataTask(with: urlImg) { data, response, error in
                        if
                            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                            let data = data, error == nil,
                            let image = UIImage(data: data) {
                            
                      //  DispatchQueue.main.async() {

            let item = NowPlayableStaticMetadata(assetURL: urlAudio, mediaType: .audio, isLiveStream: false, title: p.name,
                                                 
                                                 artist: p.address[0],
                                                 artwork:
                                                                                     
    MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
                                                                                         image
                                                                                        })
                                                                                     
                                                                                     , albumArtist: nil, albumTitle: nil)
                          //  routeAsset = item
                           // print(p.id)
                       // if routeAsset.count == count {
                            
                            
                            completion(item)
                        //}

                        } else {
                            
                            
                            let item = NowPlayableStaticMetadata(assetURL: urlAudio, mediaType: .audio, isLiveStream: false, title: p.name,
                                                                 
                                                                 artist: p.address[0],
                                                                 artwork: nil, albumArtist: nil, albumTitle: nil)
                           // routeAsset = item
                           
                                       // if routeAsset.count == count {
                                            
                                           
                                           // let arr = Array(routeAsset.sorted(by: { $0.0 < $1.0 }).map({$0.value}))
                                            completion(item)
                                       // }
                            
                            
                        }
                        
                    }.resume()
                  
                }
//                else {
//                    count -= 1
//
//                }


            //}


        
    }
    func configRoute(p: Point, completion: @escaping () -> Void) {
        
        
        getRoutesAssets(p: p) { (routeAsset) in
            
            self.routeMetadata = routeAsset
          //  ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior(), route: routeAsset)
            completion()
                
        }
    }

    func playPause() {
        DispatchQueue.main.async {
            guard self.assetPlayer != nil else {return}
            self.assetPlayer.togglePlayPause()

        }
    }
    func playPoint(_ url : URL?) {
        
       // configRoute()
       
        print("start")
        
        self.assetPlayer.play()
//
//        guard self.currentPoint?.point.images.count != 0,
//              let str = self.currentPoint?.point.images[0],
//              let img = URL(string: Link.link + str),
//              self.currentPoint?.point.address.count != 0
//              else {
//
//
//            self.assetPlayer.nowPlayableBehavior.handleNowPlayableItemChange(metadata: NowPlayableStaticMetadata(assetURL: url, mediaType: .audio, isLiveStream: false, title: self.currentPoint?.point.name ?? "", artist: self.selectedCity.city , artwork: nil , albumArtist: nil, albumTitle: nil))
//
//          //  self.assetPlayer.nextTrack()
//
//            self.assetPlayer.play()
//            self.isPlay = true
//
//
//            return }
//
//
     
//

    
    }
    
   
    
    func optIn() {
      //  self.optOut()
      //  print("optIn")
        guard assetPlayer == nil else { return }
        
        // Create the asset player, if possible.
        
        do {
            
            
            
            assetPlayer = try AssetPlayer()
            
         //   assetPlayer.player = AVQueuePlayer(items: [AVPlayerItem(asset: AVAsset(url: URL(string: s)!))])
            self.player = assetPlayer.player
        }
            
            // Otherwise, display an error.
            
        catch {
            print(error.localizedDescription)
        }
        
        
    }
    func optOut() {
        
        
        
        guard assetPlayer != nil else { return }
        
        assetPlayer.optOut()
        assetPlayer = nil
        
        ConfigModel.shared = nil
    }
 
}
