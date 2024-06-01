//
//  ImageAssetManager.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import UIKit

final class ImageAssetManager {
    static let shared = ImageAssetManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func request(_ url: URL?, completion: @escaping (UIImage?) -> Void) {
        
        guard let url else {
            completion(nil)
            return
        }
        
        let key = url.absoluteString
        
        if let cachedImage = cache.object(forKey: key as NSString) {
            completion(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, _ in
            guard let data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self?.cache.setObject(image, forKey: key as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
