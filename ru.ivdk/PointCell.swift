//
//  PointCell.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 16.01.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

struct PointCell: View {
    var i : Point
    var isCurrentPoint : Bool
    @State var duration : String = ""
    @Binding  var currentTime : String 
    @EnvironmentObject var playerOdserve : PlayerOdserve
    var body: some View {

            HStack {

                if i.images.count != 0,
                   let url = URL(string: Link.link + i.images[0]) {

                    ZStack {
                    VStack{
                    WebImage(url : url )

                        .resizable()

                        .aspectRatio(contentMode: .fill)
                     //   UrlImageView(urlString: Link.link + i.images[0], contentMode: .fill)
                    }
                
                        if isCurrentPoint && !self.playerOdserve.isPlay {
                        Image(systemName : "play.fill")
                        .foregroundColor(.white)
                            .font(.title)
                            .padding(10)
                            //.background(Circle().fill(Color.red)
                            .shadow(color: Color.black.opacity(0.45), radius: 3, x: 3, y: 3)
                            
                        } else if isCurrentPoint && self.playerOdserve.isPlay {
                            Image(systemName : "pause.fill")
                            .foregroundColor(.white)
                                .font(.title)
                                .padding(10)
                                //.background(Circle().fill(Color.red)
                                .shadow(color: Color.black.opacity(0.35), radius: 3, x: 3, y: 3)
                        }
                    
                       
                
                    }
                    .frame(width: 65, height: 65)
                    
                    .cornerRadius(5)
                    .padding(.trailing, 5)
                    .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 3, y: 3)

               
                }
                
                
                VStack(alignment: .leading) {
                    Text(i.name)
                        .fontWeight(.semibold)
                        .font(Font.system(.subheadline, design: .rounded).weight(.light))
                        .foregroundColor(isCurrentPoint ? Color.init(hex: getColor()) : .black)
                .lineLimit(2)


                    if i.address.count != 0 {

                                Text(i.address[0])
                                    .font(Font.system(.footnote, design: .rounded).weight(.light))
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                    }
                }

                Spacer()
               
                Text(isCurrentPoint ? currentTime : duration)
                     
                        .font(Font.system(.footnote, design: .rounded).weight(.light))
                        .foregroundColor(.gray)
                
                        .onAppear() {
                            if let url = URL(string: Link.link + i.audio) {
                            loadDurationDesc(url)
                                
                            }
                            
                            
                        }
                
            }
        
        .padding()
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
    func loadDurationDesc(_ url : URL) {
 
    
                
                let audioAsset = AVURLAsset.init(url: url, options: nil)
             
        audioAsset
        .loadValuesAsynchronously(forKeys: ["duration"]) {
                    var error: NSError? = nil
                    let status = audioAsset.statusOfValue(forKey: "duration", error: &error)
                    switch status {
                    case .loaded: // Sucessfully loaded. Continue processing.

                        let durationInSeconds = CMTimeGetSeconds(audioAsset.duration)

                        
                        guard !durationInSeconds.isNaN || !durationInSeconds.isInfinite else {
                            break
                        }
                        
                        
                        self.duration = audioAsset.duration.description

                    
                        break
                    case .failed: break // Handle error
                    case .cancelled: break // Terminate processing
                    default: break // Handle all other cases
                    }
                }
          
           
        
    }
}

