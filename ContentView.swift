//
//  ContentView.swift
//  BetterWeather
//
//  Created by Kacper Wojak on 08/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    
    
     @State private var weather:Weather? = nil
    
    var url:String {
        if(weather?.current.condition.icon == nil){
            return "https://cdn.weatherapi.com/weather/64x64/day/296.png"
        }else{
            return "https:"+weather!.current.condition.icon
        }
            
    }
    
    
    private func hexStringToUIColor (hex:String) -> Color {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return Color.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return Color(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            opacity: 1
        )
    }
    
    
    let manager = ApiManager()
    
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [ Color.blue,hexStringToUIColor(hex: "#1babf2")]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay( VStack{
                
                HStack(alignment: VerticalAlignment.center){
                    VStack{
                        Text(weather?.location.name ?? "Poland").font(.system(size: 18,weight: Font.Weight.semibold))
                        Text(weather?.location.region ?? "Europe").font(.system(size: 11,weight: Font.Weight.regular))
                    }
                 
                    Spacer()
                    WebImage(url:URL(string:url))
                }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            ).onAppear {
                manager.fetchWeather() {  (result: Result<Weather, Error>) in
                    switch result {
                    case .success(let w):
                        print(w)
                        weather = w
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
