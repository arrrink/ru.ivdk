//
//  LaunchView.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 15.01.2021.
//

import SwiftUI
import SSSwiftUIGIFView


struct LaunchView : View {
    
    @State var showHome = false
    @State var index = 0
          @State var show = false
    var body: some View {
        if !self.showHome {
            VStack(alignment: .center) {
                Spacer()
                HStack {
                    

                    
                    
                Text("Городские истории о немцах России")
                .foregroundColor(.white)
                    .font(Font.system(.title, design: .rounded))
                .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                .animation(.easeInOut(duration: 1.0))
                    
                }
                .padding()
                .padding(.bottom, 20)
               // VStack(alignment: .leading) {
               // Spacer()
//                HStack{
                   
                ZStack(alignment: .topTrailing) {
                    
                    
                SwiftUIGIFPlayerView(gifName: "launch")
                                        HStack {
                                        Image("logowhite")
                                            .resizable()
                                            .padding()
                                            .scaledToFit()
                                        }
                                            .frame(width: 80, height: 80)
                }.cornerRadius(10)
                    
                    .frame(width: width - 30, height: (width - 30) * 0.5625)
                    .animation(.easeInOut(duration: 1.0))
                    .padding([.horizontal, .bottom])
                    .shadow(color: Color.gray.opacity(0.3), radius: 7, x: 5, y: 5)
              //  }

                
                       // Spacer()
            Text("Уникальный онлайн путеводитель по немецким местам в российский городах")
                .foregroundColor(.white)
                .font(Font.system(.title2, design: .rounded))
                //.fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding()
            
                       // Spacer()
                HStack {
                    Spacer()
            Button(action: {
                withAnimation(.spring()) {
                    self.showHome = true
                }
            }, label: {
                Text("К выбору маршрута")
                    .foregroundColor(Color("main"))
                        .font(Font.system(.headline, design: .rounded))
                    .fontWeight(.heavy)
                    
                    .animation(.easeInOut(duration: 1.0))
                    
                    
                    
                    .padding()
                
            })
            .background(Capsule().fill(Color.white))
            .shadow(color: Color.gray.opacity(0.2), radius: 7, x: 5, y: 5)
           // .padding(.bottom)
                    Spacer()
                }
                        Spacer()
//                    }.background(
//
//                        Color("main")
//                         )
                    //.offset(y:  -35)
                    
                
                
                
                
        }
        
        .statusBar(hidden: true)
        .background(Color("main")
                    
                        .ignoresSafeArea(.all, edges: .all)
        )
            
            

            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                guard (UIApplication.shared.windows.first?.windowScene) != nil else { return }
                self.width = UIScreen.main.bounds.width
                        }
        //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height )
        } else {
            
            Home(show : self.$show)
        }
    }
    @State var width = UIScreen.main.bounds.width
    @State var scale : CGFloat = 1
}
