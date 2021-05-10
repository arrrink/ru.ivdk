//
//  ContentView.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 11.12.2020.
//

import SwiftUI
import MapKit
import AVKit
import SwiftUIPager
import SDWebImageSwiftUI
import Combine
import AVFoundation
import MediaPlayer


struct Home: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56.470926, longitude: 84.961428), span: MKCoordinateSpan(latitudeDelta: 0.003,
                                                                                                                                                        longitudeDelta: 0.003))
       
        var coordinate = Coor( coor: CLLocationCoordinate2D(latitude: 56.470926, longitude: 84.961428))
    @State var offset : CGFloat = 0
    
    @State var cornerRadius : CGFloat = 0
    
   @State var anno = [Point]()
    @State var alert = false
    @State var manager = CLLocationManager()
    @Binding var show : Bool
   // @StateObject var data  = IVDKobserve()
    @State var width = UIScreen.main.bounds.width
    @StateObject var playerOdserve = PlayerOdserve()
    @State var safeTop = UIApplication.shared.windows.last?.safeAreaInsets.top ?? 15.0
    @State var safeBottom = UIApplication.shared.windows.last?.safeAreaInsets.bottom ?? 15.0
    
    @State var bottomOffset = UIApplication.shared.windows.last?.safeAreaInsets.top ?? 15.0
    @Namespace var animation
  
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            
            MapView(manager: self.$manager, alert: self.$alert, show: self.$show)
                
               // .environmentObject(data)
                .environmentObject(playerOdserve)
           
            .alert(isPresented: self.$alert) {
            Alert(title: Text("Пожалуйста, разрешите доступ к Вашему местоположению в Настройках"))
            }
                
            ZStack {
                
              
            
            if self.playerOdserve.views.count > 0 {
                VStack {
                    Spacer()
                    CarouselViewCity(carouselLocation: self.$playerOdserve.carouselLocationCity, itemHeight: 300, views: self.$playerOdserve.views)
                    
                    .environmentObject(playerOdserve)
                   // .environmentObject(data)
                }
                .padding(.bottom, safeBottom + 10)
                .opacity(playerOdserve.showCityRoutes ? 0 : 1)
            
        }
                
                VStack {
                    if self.playerOdserve.currentPoint != nil {
                    
                        
                        //GeometryReader{reader in
                        AudioView(cornerRadius : $cornerRadius)
                            
                            
                            .environmentObject(playerOdserve)
                        //    .environmentObject(data)
                            //.preferredColorScheme(.)
                            .colorScheme(.light)
                            
                            .offset(y: self.offset)
                            .gesture(
                                DragGesture(minimumDistance: 10).onChanged({ (value) in
                                  
                                   // tracking location...
                                   
                                   // limiting value for only slider...
                                   
                                   // horizontal padding...
                                   
                           //                        if value.location.x <= UIScreen.main.bounds.width - 30 && value.location.x >= 0{
                           //
                           //                           // self.value = value.location.x
                           //                        }
                                    
                                    
                                    if self.playerOdserve.showPlayer  {
                                        
                                        withAnimation(.spring()) {
                                   self.offset = value.location.y
                                            self.cornerRadius = 35
                                        }
                                    }
                               })
                               .onEnded({ (v) in
                                
                                  /// guard self.playerOdserve.showPlayer else {return}
                                if self.playerOdserve.showPlayer &&
                                    // reader.frame(in: .global).midY
                                    v.location.y >= UIScreen.main.bounds.height / 2 {
                                   withAnimation(.spring()) {
                                    
                                    self.playerOdserve.showPlayer.toggle()
                                    
                                   }
                                }
                                
                                withAnimation(.spring()) {
                                 
                                    self.cornerRadius = 0
                                    
                                self.offset = 0
                                    
                                }
                                
                               })
                            )
                            
                   // }.frame(height: self.playerOdserve.showPlayer ?  110 : .infinity)
                        
                        if !self.playerOdserve.showPlayer {
                Spacer()
                       }
                    
                    
                }
                    
                    if !self.playerOdserve.showPlayer {
                    if playerOdserve.showCityRoutes {
                        GeometryReader{reader in
                            CityDetail(offset: self.$playerOdserve.offset, value: (-reader.frame(in: .global).height + 150 ), animation: animation)
                                     //   .environmentObject(data)
                                        .environmentObject(playerOdserve)
                                       
                                        //.padding(.top)
                                        .offset(y: reader.frame(in: .global).height - 140
                                                
                                        )
                                                            // adding gesture....
                                                                .offset(y: self.playerOdserve.offset)
                                                                .gesture(DragGesture().onChanged({ (value) in
                                                                    
                                                                    withAnimation{
                                                                        
                                                  
                                                                        
                                                                        if value.startLocation.y > reader.frame(in: .global).midX{
                                                                            
                                                                            if value.translation.height < 0 && self.playerOdserve.offset > (-reader.frame(in: .global).height + 150 + bottomOffset){
                                                                                
                                                                                self.playerOdserve.offset = value.translation.height - safeTop - 50
                                                                            }
                                                                        }
                                                                        
                                                                        if value.startLocation.y < reader.frame(in: .global).midX{
                                         
                                                                            if value.translation.height > 0 && self.playerOdserve.offset < 0{
                                                                                let h  = 150 + bottomOffset
                                                                                let j = safeTop - 50
                                                                                self.playerOdserve.offset = (-reader.frame(in: .global).height + h) + value.translation.height  - j
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                }).onEnded({ (value) in
                                                                    
                                                                    withAnimation{
                                                                        
                                                                        // checking and pulling up the screen...
                                                                        
                                                                        if value.startLocation.y > reader.frame(in: .global).midX{
                                                                            
                                                                            if -value.translation.height > reader.frame(in: .global).midX{
                                                                                
                                                                                self.playerOdserve.offset = (-reader.frame(in: .global).height + 150)
                                                                                
                                                                                return
                                                                            }
                                                                            
                                                                            self.playerOdserve.offset = 0
                                                                        }
                                                                        
                                                                        if value.startLocation.y < reader.frame(in: .global).midX{
                                                                            
                                                                            if value.translation.height < reader.frame(in: .global).midX{
                                                                                
                                                                                self.playerOdserve.offset = (-reader.frame(in: .global).height + 150)
                                                                                
                                                                              
                                                                                
                                                                                return
                                                                            }
                                                                            
                                                                            self.playerOdserve.offset = 0
                                                                        }
                                                                    }
                                                                }))
                                
                    }
                        .opacity(self.playerOdserve.showPlayer ? 0 : 1 )
                        
                    }
                }
                    
                }
                .padding(.top, self.playerOdserve.showPlayer ? 0  : safeTop )
                         //safeTop + )
                
                
          
                
              

        }
            
            
            if playerOdserve.showVideo,
              let v = playerOdserve.selectedVideo {
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
                    
                    
                    WebView(url: v)
                        .frame(width: screen.width, height : screen.width * 9 / 16)
                        //.offset( y: offsetVideoView - 10)
                        .padding(.top, 5)
                        
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


                    DispatchQueue.main.async {
                    if v.location.y >= 50 {
                    withAnimation(.spring()) {
                        
                        self.playerOdserve.showVideo = false
                        self.playerOdserve.selectedVideo = nil
                    }
                    }
                    self.offsetVideoView = 0
                }
                }))
                
            }

            
//            HStack(spacing: 15){
//
//                ForEach(self.data.cities){city in
//
//                                    CityCell(item: city)

            
//            VStack {
//                HStack{
//                Text("Выбор города")
//                    .fontWeight(.black)
//                    .foregroundColor(.white)
//                    .font(Font.system(.title3, design: .rounded))
//                 Spacer()
//                }
//                .padding(.horizontal)
//                .padding(.top, safeTop + 5)
//                Spacer()
//            CityScroll()
//                .environmentObject(data)
//                .environmentObject(detailObject)
            
            
            
        }
        .statusBar(hidden: true)
                .ignoresSafeArea()
                .onAppear {
                   // ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior(), route: [NowPlayableStaticMetadata]())
                    let span = MKCoordinateSpan(latitudeDelta: 0.003,
                                                longitudeDelta: 0.003)
                    region = MKCoordinateRegion(center: coordinate.coor,
                                                span: span)

//                    ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior(), route: [NowPlayableStaticMetadata(assetURL: URL(string: "http://agency78.spb.ru/ivdkapp/routes/moscow/1/point/1/audio.mp3")!, mediaType: .audio, isLiveStream: false, title: "", artist: nil, artwork: nil, albumArtist: nil, albumTitle: nil)])
//                   // detailObject.playPoint(URL(string : "https://agency78.spb.ru/ivdkapp/routes/moscow/1/point/1/audio.mp3")!)
                 //   self.playerOdserve.stopAudioSession()
                 //   self.playerOdserve.startAudioSession()
                    

                }
        
        
        .onReceive(timer, perform: { _ in
            guard self.playerOdserve.assetPlayer != nil else { return }
            
            
            if  !playerOdserve.player.currentTime().seconds.isNaN && !playerOdserve.player.currentTime().seconds.isInfinite {
                //print(Int(playerOdserve.player.currentTime().seconds))
            DispatchQueue.main.async {
                self.playerOdserve.cT = playerOdserve.player.currentTime().description
               }
            }
//            if !playerOdserve.player.currentTime().seconds.isNaN && !playerOdserve.player.currentTime().seconds.isInfinite {
//                print(Int(playerOdserve.player.currentTime().seconds))
//            DispatchQueue.main.async {
//                self.playerOdserve.cT = playerOdserve.player.currentTime().description
//               }
//            }
//
          //  print(self.playerOdserve.assetPlayer.playerState)
            if self.playerOdserve.assetPlayer.playerState == .playing {
                self.playerOdserve.isPlay = true
            } else {
                self.playerOdserve.isPlay = false
            }
            
            if self.playerOdserve.assetPlayer.trackState == .nextTrack  {
                
                self.playerOdserve.assetPlayer.trackState = nil
                
                self.playerOdserve.nextPoint()
                
            }
//            else if self.playerOdserve.assetPlayer.trackState == .previousTrack {
//
//                self.playerOdserve.assetPlayer.trackState = nil
//
//                self.playerOdserve.prevPoint()
//            }
//
            
        })
            
  
        

    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var offsetVideoView : CGFloat = 0.0
    @State var screen = UIScreen.main.bounds
    @State var safeAreaBottom = UIApplication.shared.windows.last?.safeAreaInsets.bottom ?? 0.0


}



struct ContentView : View {
    
   
    
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "first_start_key")
       @State var show = false
    var body: some View {
        //NavigationView {
          VStack {
            if isFirstLaunch {
                LaunchView()
            } else {
                Home(show : self.$show)
            }
          }
          
          .onAppear() {
            if isFirstLaunch {
                UserDefaults.standard.set(true, forKey: "first_start_key")
            }
            UINavigationBar.appearance().tintColor = .red
          }
//          .navigationBarTitle("home")
//        }
        
        
    }
}
