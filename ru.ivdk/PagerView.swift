//
//  Pager.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 15.01.2021.
//

import SwiftUI
import SwiftUIPager

struct PagerView: View {
    @State var page = 0
    @State var data = [Int]()
    var name : String
    var text : String
   @State var textArr = [""]
   @State var pageArr = [[String]]()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            
            
            HStack {
            

                Text(name).fontWeight(.heavy)
                    .font(.title2)
                    .foregroundColor(.black)

                
                Spacer()
                
            
            }.padding([.horizontal, .top])

            Divider()
        
           
        Pager(page : self.$page,
              data: self.data,
                      id: \.self) {
                        self.pageView($0)
                }
        .interactive(0.8)
        
        .onAppear() {
            DispatchQueue.main.async {
                self.textArr = text.components(separatedBy: " ")
                
                
                var row = [String]()
                for (n, i) in self.textArr.enumerated() {
                    
                    
                    if n != 0 && ( n % 150 == 0 || n + 1 == self.textArr.count) {
                        row.append(i)
                        self.pageArr.append(row)
                        row.removeAll()
                    } else {
                        
                        row.append(i)
                    }
                }
                
                self.data = Array(0..<pageArr.count)
                
                for k in pageArr  {

                    self.currentTextPage.append(k.joined(separator: " "))
                    
                }
                
            }
        }
        
        }
       // .navigationBarTitle(Text("Томский политехнический университет, главный корпус"), displayMode: .inline)
        .background(Color.white
        )
      
        
    }
    @State var currentTextPage = [String]()
    func pageView(_ page: Int) -> some View {
      //  ZStack {
        VStack { () -> AnyView in
                    if let _ = self.currentTextPage[safe : page] {
                        
                        return AnyView(   Text(self.currentTextPage[ page].newLines())
                            .fontWeight(.light)
                            .lineLimit(30)
                            .minimumScaleFactor(0.7)
                            
                       
                        .foregroundColor(.black)
                        //.font(Font.system(.body, design: .default))
                            
                            
                        
                        .padding()
                    )
                } else {
                    return AnyView(Text(""))
                }
                }
    
    }
}

