//
//  Music.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 18.01.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

struct AudioView: View {
    
    @EnvironmentObject var playerOdserve : PlayerOdserve
    
   // @EnvironmentObject var data : IVDKobserve

    
    @Binding var cornerRadius : CGFloat
        @State var opacity : Double = 1
        @State var height : CGFloat = 0

    @State var frame = UIScreen.main.bounds
    @State var safeTop = UIApplication.shared.windows.last?.safeAreaInsets.top ?? 0.0 + 10
    @State var safeBottom = UIApplication.shared.windows.last?.safeAreaInsets.bottom ?? 0.0 + 10
    @Environment(\.colorScheme) var colorScheme
    
    
    func getImgWidth(_ count: Int) -> CGFloat {
         
        if self.playerOdserve.showPlayer && count == 1 {
            return UIScreen.main.bounds.width - 50
        } else if self.playerOdserve.showPlayer && count != 1 {
            return 150
        } else {
            return 60
        }
         
       
    }
    var playerHStack : some View{
       return HStack{
            
                
               
            
            HStack {
                
//                if self.playerOdserve.showPlayer {
//                    Spacer()
//                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 25){
                if let a = self.playerOdserve.currentPoint,
                   let _ = a.point.images[safe : 0],
                   let url = URL(string: Link.link + a.point.images[0]) {
                    
                    ForEach(0..<a.point.images.count, id : \.self) {i in
                        
                        if i == 0 || self.playerOdserve.showPlayer ,
                            let url = URL(string: Link.link + a.point.images[i]) {
                HStack{
                    
                    if a.point.images.count == 1 && self.playerOdserve.showPlayer {
                                      Spacer()
                                   }
                   // UrlImageView(urlString: Link.link + a.point.images[i], contentMode: self.playerOdserve.showPlayer ? .fit : .fill)
                    WebImage(url: url)

                        .resizable()
                        .aspectRatio(contentMode: self.playerOdserve.showPlayer ? .fit : .fill)
                        .cornerRadius(10)
                    
                    if a.point.images.count == 1  && self.playerOdserve.showPlayer  {
                                      Spacer()
                        }
                    }
                
             
                .frame(width:
                        getImgWidth(a.point.images.count)
                       , height: self.playerOdserve.showPlayer ? 150 : 60)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(self.playerOdserve.showPlayer ? 0.35 :0),radius: 8,x: 8,y: 8)
                .shadow(color: Color.white.opacity(self.playerOdserve.showPlayer ? 1 : 0),radius: 10,x: -10,y: -10)
                
                    
                .onTapGesture {
                    withAnimation(.easeOut(duration : 0.4)) {
                        self.playerOdserve.showPlayer.toggle()
                    }
                }
                    
                }
                }
            }
                }.padding( self.playerOdserve.showPlayer ? 25 : 0)
                }
                
                .frame(width:
                        self.playerOdserve.showPlayer ? .infinity : 60)
//                if self.playerOdserve.showPlayer {
//                    Spacer()
//                }
            }
            
            if !self.playerOdserve.showPlayer {
            
            VStack(alignment : .leading){
                
                if let cP = self.playerOdserve.currentPoint,
                 let _ = self.playerOdserve.cities[safe : self.playerOdserve.currentPoint!.cityID - 1],
                 let _ = self.playerOdserve.currentPoint!.point.address[safe : 0],
                 let address = self.playerOdserve.currentPoint!.point.address[0]
                 
                {
                    
                Text(cP.point.name)
                    .font(.subheadline)
                    .fontWeight(.light)
                  
                   
                   
                
                   
                    
                    
                    Text(address)
                        .font(.caption)
                   
                   
                }
             

            }
            .frame( height: 60)
                
            .onTapGesture {
                withAnimation(.easeOut(duration : 0.4)) {
                    self.playerOdserve.showPlayer.toggle()
                }
            }
                
                
            Spacer()
            

                Button {
                    self.playerOdserve.playPause()
                    
                } label: {
                    
                

                    if !self.playerOdserve.isPlay {
                Image(systemName : "play.fill")
                    .font(.system(size: 17, weight: .bold))
                   // .font(.title)
    
                } else {
                    Image(systemName : "pause.fill")
                        .font(.system(size: 17, weight: .bold))
                        //.font(.title)

                    
                }
                }
            
        }
            
            
        
            
            
        }
       .padding(.horizontal, !self.playerOdserve.showPlayer ? 30 : 0)
        .foregroundColor( .white)
        
        
    }
    
    func getColor() -> String {
       if let cP = self.playerOdserve.currentPoint{
            
        // withAnimation(.easeOut(duration : 0.4)) {
            return self.playerOdserve.cities[cP.cityID - 1].routes?[cP.routeID - 1]?.color ?? "#FF1C24"
            //}
       } else {
        return "#FF1C24"
       }
    }
        var body : some View{
            
            
                
                
                    
            ZStack {
                if self.playerOdserve.showPlayer {
                 ZStack {
                    if colorScheme == .light {
                        
                        
                        Color("Color")
                            .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                         .animation(.easeOut)
                            .cornerRadius(cornerRadius)
                        
                        
                           
                        
                    } else {
                    Blur(style : .systemUltraThinMaterialDark)
                        .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                     .animation(.easeOut(duration : 0.4))
                    }
                }

                 .onTapGesture {
                     withAnimation(.easeOut(duration : 0.4)) {
                         self.playerOdserve.showPlayer.toggle()
                     }
                 }
                 
                  
                 
                }

                    
                    VStack{
                        if self.playerOdserve.showPlayer {
                            Capsule()
                                .fill(Color.init(hex: getColor()).opacity(0.9))
                                            .frame(width: 65, height: 3)
                                            .padding(.top, 25)
                                            //.padding(.bottom,25)
                                .opacity(cornerRadius == 35 ? 0 : 1)
                            Spacer()
                        }
                        playerHStack
                           
                            .padding(.vertical, self.playerOdserve.showPlayer ? 50 : 0)
                        .background(
                            ZStack {
                                if colorScheme == .light{
                                    
                                 withAnimation(.easeOut(duration : 0.4)) {
                                    Color.init(hex: getColor())
                                        .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                                 }
                                } else {
                                Blur(style : .systemUltraThinMaterialDark)
                                    .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                                }
                            }
                            .cornerRadius(10)
                            .padding()
                            
                                
                            .frame(width: nil, height: 110)
                            .opacity(self.playerOdserve.showPlayer ? 0 : 1)
                            
                        )
                            .padding(.top, !self.playerOdserve.showPlayer ? safeTop + 10 : 0)
                        if self.playerOdserve.showPlayer {
                           // Spacer()
                            VStack{

                                if let cP = self.playerOdserve.currentPoint,
                                       let _ = self.playerOdserve.cities[safe : cP.cityID - 1],
                                       let _ = cP.point.address[safe : 0],
                                       let address = ", " + cP.point.address[0] {
                                    
                                    
                                    
                                        
                                        Button(action: {
                                            
                                              
                                            let controller = UIHostingController(rootView: AnyView(PagerView(name: self.playerOdserve.currentPoint?.point.name ?? "", text: self.playerOdserve.currentPoint?.point.text ?? "")))
                                                                                                          
                                                if let window = UIApplication.shared.windows.last {
                                                window.rootViewController?.present(controller, animated: true, completion: nil)
                                                }
                                                
                                                    
                                            
                                            
                                            
                                        }) {
                                            HStack{
                                                
                                                Text("Читать")
                                                    .fontWeight(.semibold)
                                                    .font(.caption)
                                                Image(systemName : "book")
                                                    

                                               // .font(.title3)
                                                
                                           // .frame(width: 50, height: 50)
                                        }
                                            .foregroundColor(Color.init(hex: getColor()))
                                            
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                            .background(Capsule().fill(Color.white)
                                            
                                                            .shadow(color: Color.init(hex: getColor()).opacity(0.6),radius: 5,x: 5,y: 5)
                                                            .shadow(color: Color.white,radius: 5,x: -5,y: -5)
                                            )
                                                  
                                        }
                                        .padding(.bottom)
                                   
                                   
                         //    Timings...
                            Description(name : cP.point.name,
                                        text: self.playerOdserve.cities[cP.cityID - 1].city + address)
                               
                                .padding(.horizontal)
                              
                                }
                               // Spacer()
                            fullAudioView
                            }
                        }
                       
                        
                       
                        
                    }
                    
                    .padding(.top, safeTop + 5)
                    .padding(.bottom, safeBottom + 5)
//                    .background(
//
//                        bgMax()
//
//                    )
        }
                    //.frame(width:  self.frame.width, height : self.frame.height)
//            .offset( y: self.offset)
//            .gesture(
//                DragGesture().onChanged({ (value) in
//                    print(value.location.y)
//                   // tracking location...
//                   
//                   // limiting value for only slider...
//                   
//                   // horizontal padding...
//                   
//           //                        if value.location.x <= UIScreen.main.bounds.width - 30 && value.location.x >= 0{
//           //
//           //                           // self.value = value.location.x
//           //                        }
//                    
//                    
//                    if self.playerOdserve.showPlayer  {
//                   self.offset = value.location.y
//                    }
//               })
//               .onEnded({ (v) in
//                
//                  /// guard self.playerOdserve.showPlayer else {return}
//                   
//                   withAnimation(.spring()) {
//                    
//                    
//                    self.offset = 0
//                   }
//               })
//            )
                                
        }
    
    
    
   // let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //    @State var cT = ""
    var fullAudioView : some View {
        VStack{

            
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
                
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 6)
                
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
                    
                    if let cI = self.playerOdserve.player.currentItem{
                       
                    Capsule()
                        .fill(Color.init(hex: getColor()).opacity(0.6))
                        .frame(width:  ( UIScreen.main.bounds.width - 30) *  CGFloat(self.playerOdserve.player.currentTime().seconds) / CGFloat(cI.duration.seconds) ,height: 6)
                    
                }

                    // Drag Button....
                    
                    Circle()
                        .fill(Color.init(hex: getColor()).opacity(0.7))
                        .frame(width: 10, height: 10)
                        .padding(.all, 10)
                        .background(Color("Color"))
                        .clipShape(Circle())
                    // adding shadow...
                        .shadow(color: Color.init(hex: getColor()).opacity(0.6),radius: 10,x: 4,y: 2)
                    
                
                }
            })
            // adding gesture...
            
            .padding(.top, 8)
            
            
            HStack{

                Text(self.playerOdserve.cT)
                    .font(.caption2)
                    .foregroundColor(.gray)

                Spacer()
                if self.playerOdserve.player != nil,
                    let cI = self.playerOdserve.player.currentItem,
                   
                   let cT = self.playerOdserve.player.currentTime().seconds,
                   
                   let d = cI.duration.seconds - cT,
                   
                   let desc = CMTime(seconds: d, preferredTimescale: 1 ).description   {
                    Text("-" + ((cI.duration.seconds.isNaN || cI.duration.seconds.isInfinite )  ? "" : desc))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    
                }
            }
           // .padding(.top, 25)
            
            // adding Playback Buttons...
            PlaybackButtonsView(color : getColor())
            .environmentObject(playerOdserve)
            
           
            Spacer()
        }
        .padding()
    }
   // @State var value : CGFloat = 3

      
}

struct Description : View {
    var name: String
    var text : String
    
   
    var body: some View {
        VStack {
        HStack {
            
            
            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
               // .padding(.top, 8)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.leading)
               // .frame(width: UIScreen.main.bounds.width - 30)
        
                Spacer()
    }
            HStack {
            Text(name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
               // .padding(.top, 25)
                //.fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
            
            Spacer()
            }
        
    }
    }
}
struct PlaybackButtonsView: View {
    var color : String
    @EnvironmentObject var playerOdserve : PlayerOdserve
    var body : some View {
       // VStack{
        HStack(spacing: 20){
            
            Button(action: {
                self.playerOdserve.prevPoint()
            
            }, label: {
                
                Image(systemName: "backward.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.all, 25)
                    .background(Color("Color"))
                    .clipShape(Circle())
                // adding shadow...
                    .shadow(color: Color.init(hex: color).opacity(0.6),radius: 5,x: 5,y: 5)
                    .shadow(color: Color.white,radius: 5,x: -5,y: -5)
            })
            
            Button(action: {
                    guard self.playerOdserve.assetPlayer != nil else {return}
                    self.playerOdserve.assetPlayer.togglePlayPause()}, label: {
                
                        Image(systemName: "\(self.playerOdserve.isPlay ? "pause" : "play").fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.all, 25)
                    .background(Color.init(hex: color))
                    .clipShape(Circle())
                // adding shadow...
                    .shadow(color: Color.init(hex: color).opacity(0.6),radius: 5,x: 5,y: 5)
                    .shadow(color: Color.white,radius: 5,x: -5,y: -5)
            })
            
            Button(action: {
                self.playerOdserve.nextPoint()
                
            }, label: {
                
                Image(systemName: "forward.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.all, 25)
                    .background(Color("Color"))
                    .clipShape(Circle())
                // adding shadow...
                    .shadow(color: Color.init(hex: color).opacity(0.6),radius: 5,x: 5,y: 5)
                    .shadow(color: Color.white,radius: 5,x: -5,y: -5)
            })
           
        }
        .padding(.bottom)
//    }
       
    }
}
