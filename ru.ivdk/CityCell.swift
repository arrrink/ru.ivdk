//
//  CityView.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 15.01.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct CityCell: View {
    var item : CityView
    @State var width = UIScreen.main.bounds.width
    @EnvironmentObject var playerOdserve : PlayerOdserve
//    @EnvironmentObject var data : IVDKobserve
    var body: some View {
        VStack(alignment: .leading, spacing: 0 ) {
            if let url = URL(string: Link.link + item.image) {
            VStack(alignment: .leading) {
                WebImage(url: url)

                    .resizable()
                .scaledToFill()

            //    UrlImageView(urlString: Link.link + item.image, contentMode: .fill)
            }.frame(width: width * 3 / 4, height: 140)

            .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)
        }
           
            VStack(alignment: .leading, spacing: 5) {
            
            
            Text(item.city)
               // .font(.title2)
                .fontWeight(.black)
                .font(Font.system(.subheadline, design: .default))
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top, 10)

                
            Text(item.routesCount)
                .fontWeight(.light)
                .font(Font.system(.footnote, design: .rounded))
               
                .foregroundColor(.black)
                .padding(.horizontal)
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
            playerOdserve.selectedCity = item
            

            
            playerOdserve.showCityRoutes.toggle()
            
            self.playerOdserve.focusCity = item
            
            self.playerOdserve.updateMap = true
        }
    
    }
    }
}
