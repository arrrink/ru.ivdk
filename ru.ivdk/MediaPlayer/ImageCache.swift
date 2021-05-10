//
//  ImageCache.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 01.02.2021.
//


import Foundation
import SwiftUI

struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    var contentMode : ContentMode
    init(urlString: String?, contentMode : ContentMode) {
        urlImageModel = UrlImageModel(urlString: urlString)
        self.contentMode = contentMode
    }
    
    var body: some View {
        
        if let img = urlImageModel.image {
        Image(uiImage: img)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            
        } else {
            Image("logomain")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color("ColorMain"))
            .rotationEffect(Angle(degrees: -15.0))
            .opacity(0.2)
            .aspectRatio(contentMode: .fit)
            .scaledToFit()
                .padding(50)
        }
            
    }
    
    static var defaultImage = UIImage(named: "")
}

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var urlString: String?
    var imageCache = ImageCache.getImageCache()
    
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
    
    func loadImage() {
        if loadImageFromCache() {
          //  print("Cache hit")
            return
        }
        
       // print("Cache miss, loading from url")
        loadImageFromUrl()
    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    func loadImageFromUrl() {
        guard let urlString = urlString else {
            return
        }
        
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            
            self.imageCache.set(forKey: self.urlString!, image: loadedImage)
            self.image = loadedImage
        }
    }
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
