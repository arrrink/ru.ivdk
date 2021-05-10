//
//  RouteView.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 16.01.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

import MediaPlayer


struct RouteView: View {
    @State var screen = UIScreen.main.bounds
    @State var topPadding = UIApplication.shared.windows.first!.safeAreaInsets.top
    var route : Route
    @Binding var showRoute : Bool
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var playerOdserve : PlayerOdserve

    //@EnvironmentObject var data : IVDKobserve
    

    
    @State var showVideo = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
       
    var body: some View {
        // Route
        
        ZStack(alignment: .bottom) {
            //if !showVideo {
        VStack{
            
Spacer()
           // ZStack(alignment: .top) {
                   
                    VStack {
                        Capsule()
                            .fill(Color.white.opacity(0.9))
                                        .frame(width: 50, height: 5)
                                        .padding(.top)
                                        //.padding(.bottom,25)
                        HStack(alignment: .top){

                        
                            
                            Image(systemName: "chevron.left")
                                
                                .foregroundColor(Color.white)
                                
                                
                                .font(Font.system(.title2, design: .rounded).weight(.heavy))
                                
                                //.background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        
                      
                        Text(route.name)
                            .font(Font.system(.body, design: .default))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                          //  .matchedGeometryEffect(id: "city" + String(detail.selectedItem.id), in: animation)
                            
                               
                               
                        
                        
                        Spacer()
                       
                    }
                    .padding(.horizontal, 15)
                    .onTapGesture {
                        withAnimation(.spring()){

                            self.showRoute = false
                            
                        }
                    
                    }
                       
                            
                            if let _ = route.points {
                                VStack {
                                    Spacer()
                                    HStack(spacing: 10) {
                                
                                Spacer()
                                        if let str = route.desc {
                                            
                                            
                                            Button(action: {
                                                
                                                
                                              //  withAnimation(.spring()){

                                                    
                                                    let controller = UIHostingController(rootView: AnyView(PagerView(name: self.playerOdserve.selectedRoute.name , text: self.playerOdserve.selectedRoute.desc ?? "")))
                                                
                                              //  controller.modalPresentationStyle = .custom
                                             //   controller.modalPresentationStyle = .overCurrentContext
                                                
                                                
                                                    if let window = UIApplication.shared.windows.last {
                                                        window.rootViewController?.present(controller, animated: true, completion: nil)
                                                    }
                                                    
                                                
                                                
                                                
                                            }) {
                                                
                                                Image(systemName : "book")

                                                        .foregroundColor(.init(hex: route.color))
                                                        .font(.title2)
                                                 
                                                .padding(10)
                                                .frame(width: 50, height: 50)
                                               
                                                .background(Circle().fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                                                )
                                                      
                                            }
                                            
                                            

                                           
                                        }
                                            if let str = route.video,
                                               let url = URL(string: str) {
                                                
                                                
                                                Button(action: {
                                                    self.showVideo = true

                                                }) {
                                                    
                                                    Image(systemName : "video")

                                                            .foregroundColor(.init(hex: route.color))
                                                            .font(.title2)
                                                     
                                                    .padding(10)
                                                    .frame(width: 50, height: 50)
                                                   
                                                        .background(Circle().fill(Color.white)
                                    
                                                    .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                                                    )
                                                    
                                                }
//                                                .sheet( height: .points(screen.width * 9 / 16 + 50), isPresented: self.$showVideo, content: {
//
//                                                    return AnyView(
//                                                        VStack(spacing: 0){
//                                                        HStack {
//
//
//                                                                .fontWeight(.heavy)
//                                                                .font(.title2)
//                                                                .foregroundColor(.black)
//
//
//                                                            Spacer()
//
//
//                                                        }.padding(.horizontal)
//
//
//                                                        .frame(height: 50)
//                                                            Divider()
//                                                            WebView(url: url)
//                                                                            .frame(width: screen.width, height : screen.width * 9 / 16)
//                                                }
//
//                                                        .background(Color.white)
//                                                      )
//
//
//
//
//
//                                                })


                                                
                                               

                                               
                                            }
                                
                                
                                Button(action: {
                                    
                                    
                                    if let r = self.playerOdserve.cities[self.playerOdserve.selectedCity.id - 1].routes,
                                       let points = r[route.id - 1]?.points,
                                       points.count > 0,
                                       let p = points[0] {
                                        
                                        let d = self.playerOdserve
                                       // self.playerOdserve.tapAudio(p)
                                        d.changePoint(cP: CurrentPoint(cityID: d.selectedCity.id, routeID: d.selectedRoute.id, point: p))
                                    } 
                                    
                                    
                                }) {
                                    
                                    
                                    if self.playerOdserve.selectedRoute.id == self.playerOdserve.currentPoint?.routeID &&
      self.playerOdserve.selectedCity.id == self.playerOdserve.currentPoint?.cityID &&    self.playerOdserve.isPlay {
    
                                        Image(systemName : "pause")

                                                .foregroundColor(.init(hex: route.color))
                                                .font(.title2)
                                         
                                        .padding(10)
                                        .frame(width: 50, height: 50)
                                       
                                        .background(Circle().fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                                        )
                                    } else {
                                        Image(systemName : "play")

                                                .foregroundColor(.init(hex: route.color))
                                                .font(.title2)
                                         
                                        .padding(10)
                                        .frame(width: 50, height: 50)
                                       
                                        .background(Circle().fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                                        )
                                    }
                                    
                                }
                                
                                
//                                Text(String(r.count) + " точек")
//                                    .font(Font.system(.body, design: .default))
//                                    .fontWeight(.black)
//                                    .foregroundColor(.white)
                                
                                
                            }
                            .padding(.horizontal, 15)
                       
                                    
                                  
                            } .padding(.bottom)
                            }
                        
                }
                    

                  
               // }
               
                    .background(
                        ZStack{
                           
                        if let img = route.image,
                           let url = URL(string: Link.link + img) {
                            VStack {
                        WebImage(url: url )

                            .resizable()
                            .scaledToFill()
                               // UrlImageView(urlString: Link.link + img, contentMode: .fill)
                            .frame(width: self.screen.width - 33, height: self.playerOdserve.dinamicHeight)
                            .background( Color(hex: route.color))
                        }
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(colorScheme == .dark ? 0 : 0.5), radius: 5, x: 5, y: 5)
                                .padding(.horizontal)
                           
                        }
            
        }
                    )
                    
                    .frame(width: self.screen.width - 33, height: self.playerOdserve.dinamicHeight)

          //  Spacer(minLength: 30)
                if let points = route.points {
                
               
                   
                      
                    VStack(alignment: .leading) {
                        ScrollView(.vertical, showsIndicators: false) {
                            
                           // VStack(spacing: 0) {
                                ForEach(points, id : \.self) { point -> AnyView in
                           
                            if let i = point {
                                
                                let isCurrentPoint : Bool
                                
                                if CurrentPoint(cityID: playerOdserve.selectedCity.id, routeID: route.id, point: i) == playerOdserve.currentPoint {
                                    isCurrentPoint = true
                                } else {
                                    isCurrentPoint = false
                                }
                                
                              
                              return AnyView(
                                PointCell(i: i, isCurrentPoint: isCurrentPoint, currentTime: self.$playerOdserve.cT).environmentObject(playerOdserve)
                                
                                    .onTapGesture {
                                        let d = self.playerOdserve
                                        if isCurrentPoint {
                                            d.playPause()
                                        } else {
                                            
                                           /// d.optIn()
                                            
                                           // self.playerOdserve.tapAudio(p)
                                            d.changePoint(cP: CurrentPoint(cityID: d.selectedCity.id, routeID: d.selectedRoute.id, point: i))
                                        
                                       // self.playerOdserve.tapAudio(i)
                                        }
                                    }
                                   
                                
                                
                                
                                )

                            }
                            else {
                                return AnyView(EmptyView())
                            }
                        }
                    // }
                            
                            
                        
                            .padding()
                                
                    }
                        
                        .background(
                            Color.white

                               
                                .cornerRadius(10)
                                .padding(.horizontal)
                               
                                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 5, y: 5)

                        )
                        
                   
                }
                       
                    
                   
                    .padding(.bottom, safeAreaBottom + 15)
                
                    
                
            }

            }
//        .onAppear() {
//            DispatchQueue.main.async {
//
//
//            withAnimation(.spring()){
//
//                self.offset += 150
//                                }
//            }
//        }
//
        
//        .onReceive(timer, perform: { _ in
//            if !playerOdserve.player.currentTime().seconds.isNaN && !playerOdserve.player.currentTime().seconds.isInfinite {
//                //print(Int(playerOdserve.player.currentTime().seconds))
//            DispatchQueue.main.async {
//                self.playerOdserve.cT = playerOdserve.player.currentTime().description
//               }
//            }
//
//
//
//
//        })
            if showVideo,
               let str = route.video,
                   let url = URL(string: str) {
                //videoview
                
                    
                VStack(spacing: 0){
                    Capsule()
                        .fill(Color.gray.opacity(0.6))
                                    .frame(width: 50, height: 5)
                                    .padding(.top)
                HStack {
                

                    Text("Просмотр видео")
                        .fontWeight(.heavy)
                        .font(.body)
                        .foregroundColor(.black)

                    
                    Spacer()
                    
                
                }.padding()
                    
                    
                    WebView(url: url)
                        .frame(width: screen.width, height : screen.width * 9 / 16)
                        .offset( y: -10)
                        .padding(.top)
                        
                }
                
                //.ignoresSafeArea(.all, edges: .all)
               
                .animation(.easeInOut)
                .padding(.bottom, UIApplication.shared.windows.last?.safeAreaInsets.bottom ?? 0.0)
                .background(RoundedCorners(color: Color.white, tl: 10, tr: 10, bl: 0, br: 0)
                    .shadow(color: Color.gray.opacity(0.6), radius: 5, y: -5))
                //.frame(width: screen.width, height : screen.width * 9 / 16 + 50)
                .offset( y: offsetVideoView)
                .highPriorityGesture(DragGesture().onChanged({ (v) in
                    if  v.location.y >= 0 {
                        DispatchQueue.main.async {
                            
                            withAnimation() {
                        self.offsetVideoView =  v.location.y
                            }
                        }}
                }).onEnded({ (v) in
                   // print(v.location.y)
                    let h = screen.height - (screen.width * 9 / 16 + 55 + safeAreaBottom)
                    DispatchQueue.main.async {
                    if v.location.y >= 50 {
                    withAnimation(.spring()) {
                        
                        self.showVideo = false
                    }
                    }
                    self.offsetVideoView = 0
                }
                }))
                
            }
    }
        .onAppear() {
          //  configRoute()
            self.playerOdserve.zoomToRoute = true
     
        }
           
//            
//            
//                
//        }
       
}
    
    @State var safeAreaBottom = UIApplication.shared.windows.last?.safeAreaInsets.bottom ?? 0.0
    
    @State var offsetVideoView : CGFloat = 0.0
    
   


}

