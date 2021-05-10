//
//  RouteCell.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 18.01.2021.
//


import SwiftUI
import SDWebImageSwiftUI

struct RouteCell: View {
    var item : Route
    
    @State var screen = UIScreen.main.bounds
    @State var width = UIScreen.main.bounds.width
    
    @EnvironmentObject var playerOdserve : PlayerOdserve
   // @EnvironmentObject var data : IVDKobserve
    var body: some View {
        VStack(alignment: .leading, spacing: 0 ) {
            if let str = item.image,
                let url = URL(string: Link.link + str) {
                ZStack(alignment: .trailing) {
            WebImage(url: url)

                    .resizable()
                .scaledToFill()
                  //  UrlImageView(urlString: Link.link + str, contentMode: .fill)
                    .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)
               // .blur(radius: 0.7)
                
               
                
              //  VStack {
                   // Spacer()
                    VStack(spacing: 10) {
                
              //  Spacer()
                        if let route = item,
                            let str = route.desc {


                            Button(action: {

                              //  withAnimation(.spring()){


                                let controller = UIHostingController(rootView: AnyView(PagerView(name: route.name , text: route.desc ?? ""))
                                                                                              )
                                    if let window = UIApplication.shared.windows.last {
                                    window.rootViewController?.present(controller, animated: true, completion: nil)
                                    }




                            }) {

                                Image(systemName : "book")

                                        .foregroundColor(.init(hex: route.color))
                                    //    .font(.title3)

                                .padding(10)
                               // .frame(width: 50, height: 50)

                                    .background(Circle().fill(Color.white)
                                .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                                )

                            }




                        }
                            if let route = item,
                                let str = route.video,
                               let url = URL(string: str) {
                                
                                
                                Button(action: {
                                    self.playerOdserve.showVideo = true
                                    
                                    self.playerOdserve.selectedVideo = url
                                    

                                }) {
                                    
                                    Image(systemName : "video")

                                            .foregroundColor(.init(hex: route.color))
                                            //.font(.title3)
                                     
                                    .padding(10)
                                   // .frame(width: 50, height: 50)
                                   
                                        .background(Circle().fill(Color.white) .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                    
                                   
                                    )
                                    
                                }
//                                .sheet( height: .points(screen.width * 9 / 16 + 50), isPresented: self.$showVideo, content: {
//
//                                    return AnyView(
//                                        VStack(spacing: 0){
//                                        HStack {
//                                            Text("Просмотр видео")
//                                                .fontWeight(.heavy)
//                                                .font(.title2)
//                                                .foregroundColor(.black)
//                                            Spacer()
//                                        }.padding(.horizontal)
//                                        .frame(height: 50)
//                                            Divider()
//                                            WebView(url: url)
//                                                            .frame(width: screen.width, height : screen.width * 9 / 16)
//                                }
//                                        .background(Color.white)
//
//                                      )
//                                })
   
                            }
                

                
            }
            .padding(.horizontal, 10)
       
                    
                  
            
                //.padding(.bottom)
                
                
                
            }.frame(width: width * 3 / 4, height: 140)

           
        }
           
            VStack(alignment: .leading, spacing: 5) {
            
            
                Text(item.name)
                .font(.subheadline)
                .fontWeight(.black)
               // .font(Font.system(.title3, design: .default))
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top, 10)

                
//                Text(item.name)
//                .fontWeight(.light)
//                .font(Font.system(.footnote, design: .rounded))
//
//                .foregroundColor(.black)
//                .padding(.horizontal)
                if let desc = item.desc {
                    Text(desc.replacingOccurrences(of: "\n", with: " "))
                
                .fontWeight(.light)
                .lineLimit(4)
                .font(Font.system(.caption, design: .default))
                //  .font(.footnote)
                
                .foregroundColor(.black)
                .padding(.horizontal)
                //.padding(.bottom)
                }
            
        }
       
            .padding(.bottom)
        .background(Color.white
                        .frame(width: width * 3 / 4)
                        .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)
        
        )
            .frame(width: width * 3 / 4)
    
       
        }
       
        
        .cornerRadius(10)
        //.clipShape(CustomShape())

        .padding(.vertical)

        .onTapGesture {
        
        withAnimation(.spring()){
            playerOdserve.selectedRoute = item
            
            playerOdserve.routeID = item.id
            
            playerOdserve.showRoute.toggle()
            
           // self.data.focusCity = item
            
          //  self.data.updateMap = true
        }
    
    }
        
        
    }
}
