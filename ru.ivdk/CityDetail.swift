//
//  CityDetail.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 16.01.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct CityDetail: View {
    // Getting Current Selected Item...
    @EnvironmentObject var playerOdserve : PlayerOdserve
  //  @EnvironmentObject var data : IVDKobserve
    @State var screen = UIScreen.main.bounds
    @State var topPadding = UIApplication.shared.windows.first!.safeAreaInsets.top
    
    @State var scale : CGFloat = 1
    @State var round : CGFloat = 0.0
  //  @State var offset : CGFloat = 0.0
    @Environment(\.colorScheme) var colorScheme
    @State private var contentOffset: CGPoint = .zero
    
    @State var safeBottom = UIApplication.shared.windows.last?.safeAreaInsets.bottom ?? 15.0

    
    
    var screenCalc : CGFloat { return UIScreen.main.bounds.width * 3 / 4 - (UIScreen.main.bounds.width * 3 / 4 * 1 / 3 )}
    @Binding var offset : CGFloat
        var value : CGFloat
    var animation: Namespace.ID
    var body: some View {
        ZStack {
        VStack {
            if !self.playerOdserve.showRoute {
            
            VStack{
               
                if offset == value {
                    Spacer()
                }
                
                    VStack {
                    Capsule()
                        .fill(Color.white.opacity(0.9))
                                    .frame(width: 50, height: 5)
                                    .padding(.top)
                                    //.padding(.bottom,25)
                HStack{

                    
                        
                        Image(systemName: "chevron.left")
                            
                            .foregroundColor(Color.white)
                            
                            
                            .font(Font.system(.title2, design: .rounded).weight(.heavy))
                            
                            //.background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    
                  
                    Text(playerOdserve.selectedCity.city)
                        .font(Font.system(.body, design: .default))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .matchedGeometryEffect(id: "city" + String(playerOdserve.selectedCity.id), in: animation)
                        

                        
                           
                           
                    
                    
                    Spacer()
                   
                }
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation(.spring()){

                        self.playerOdserve.showCityRoutes.toggle()
                    }
                
                }
                    
                    Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                          
                            let controller = UIHostingController(rootView: AnyView(PagerView(name: self.playerOdserve.selectedCity.city, text: self.playerOdserve.selectedCity.desc)))
                                                                                      
                            if let window = UIApplication.shared.windows.last {
                            window.rootViewController?.present(controller, animated: true, completion: nil)
                            }
                            
                                
                        
                        
                        
                    }) {
                        HStack{
                            
                            Text("Читать о городе")
                              //  .fontWeight(.light)
                                .font(.caption)
                            Image(systemName : "book")

                           // .font(.title3)
                            
                       // .frame(width: 50, height: 50)
                    }
                        .foregroundColor(.red)
                        
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(Capsule().fill(Color.white)
                        .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                        )
                              
                    }
                    
                }.padding(.horizontal, 15)
                .padding(.bottom)

                
                    
            }
                

              
           // }
           // .frame(width: self.screen.width - 30, height: screen.height / 2.5)
                .background(
                    ZStack{
                        
                        if let url = URL(string: Link.link + playerOdserve.selectedCity.image){
                  
                        VStack {
            WebImage(url: url )
                           // UrlImageView(urlString: Link.link + playerOdserve.selectedCity.image, contentMode: .fill)
                        .resizable()
                       // .aspectRatio(contentMode: .fill)
                        .scaledToFill()
                        .frame(width: self.screen.width - 33, height: self.playerOdserve.dinamicHeight)
                            
                     
                    }
                       // .frame(width: UIScreen.main.bounds.width - 30)
                       
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(colorScheme == .dark ? 0 : 0.5), radius: 5, x: 5, y: 5)
                           
                        .padding(.horizontal)
                    }
        
    }
                )
                      
                .frame(width: self.screen.width - 33, height: self.playerOdserve.dinamicHeight)
                .padding(.horizontal)
               
                if let _ = self.playerOdserve.viewsRoutes[safe : self.playerOdserve.selectedCity.id - 1]  {
                    VStack {
                    
                        CarouselViewRoute(carouselLocation: self.$playerOdserve.carouselLocationRoute,itemHeight: self.playerOdserve.dinamicHeightRouteCar, views: self.$playerOdserve.viewsRoutes[self.playerOdserve.selectedCity.id - 1] )
                        
                        .environmentObject(playerOdserve)
                            .padding(.bottom, safeBottom + 10)
                       // .environmentObject(data)
                    }
                    
                   
                    
                    
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        ForEach(r, id : \.self) { route in
//                            if let i = route {
//                            VStack {
//
//                                HStack {
//
//
//
//                                Text(i.name)
//                                    .foregroundColor(.white)
//                                    .font(Font.system(.body, design: .rounded).weight(.light))
//                                    .lineLimit(4)
//                                     .frame(width: screenCalc - 30)
//
//                                    .padding()
//
//                                    .onTapGesture() {
//
//
//                                        playerOdserve.selectedRoute = i
//
//                                        withAnimation(.spring()) {
//                                            self.showRoute = true
//                                        }
//                                    }
//
//                                }
//
//                            }
//
//                            .background(Color(hex: i.color)
//
//                                            .shadow(color: Color.gray.opacity(colorScheme == .dark ? 0 : 0.5), radius: 5, x: 5, y: 5)
//
//                            )
//                            .frame(width: screen.width * 3 / 4)
//                            .cornerRadius(35)
//                        }
//                        }
//                    }
//                    .padding(.horizontal)
//                }

                //.padding(.top, topPadding + 15)
            }
               
//                VStack {
//
//                Text(playerOdserve.selectedCity.desc)
//                    .font(Font.system(.subheadline, design: .default))
//                    .fontWeight(.light)
//                  // .lineLimit(10)
//                  //  .fixedSize(horizontal: false, vertical: true)
//                    .padding()
//                    .foregroundColor(.black)
//
//                }
//
//
//                .background(
//
//                        RoundedCorners(color: Color.white, tl: 10, tr: 10, bl: 10 , br: 10)
//                                .shadow(color: Color.gray.opacity(colorScheme == .dark ? 0 : 0.5), radius: 5, x: 5, y: 5))
//                .padding()
//
//
//                    .onTapGesture {
//                        withAnimation(.spring()) {
//                            self.playerOdserve.showCityDesc = true
//                        }
//                    }

            }
        
       
            .onAppear() {
                DispatchQueue.main.async {
                    
                
                withAnimation(.spring()){
                                        
                    self.offset = value
                                    }
                }
            }
            
        

            .ignoresSafeArea(.all, edges: .top)
            .opacity(self.playerOdserve.showRoute ? 0 : 1)
            
        
    }
        else {
            RouteView(route: playerOdserve.selectedRoute, showRoute : self.$playerOdserve.showRoute)
                        .environmentObject(playerOdserve)
                .onAppear() {
                    DispatchQueue.main.async {
                        
                    
                    withAnimation(.spring()){
                            
                        let fromMap = self.playerOdserve.fromMap
                        self.offset = fromMap ? -safeBottom : value
                            //value
                        
                        self.playerOdserve.fromMap = fromMap ? false : false
                                        }
                    }
                }
              //  .environmentObject(data)
    }
        }
        //.opacity(self.playerOdserve.showCityDesc ? 0 : 1)
            
            
        }
    }
   
    func onChanged(value: DragGesture.Value){
        
        // calculating scale value by total height...
        
        let scale = value.translation.height / screen.height
        
        // if scale is 0.1 means the actual scale will be 1- 0.1 => 0.9
        // limiting scale value...
        
        if 1 - scale > 0.75{
        
            self.scale = 1 - scale
        }
        withAnimation(.spring()) {
            self.round = 45
        }
    }
    
    func onEnded(value: DragGesture.Value){
        
        withAnimation(.spring()){
            
            // closing detail view when scale is less than 0.9...
            if scale < 0.9{
                playerOdserve.showCityRoutes.toggle()
            }
            scale = 1
            
            self.round = 0
        }
    }
}
