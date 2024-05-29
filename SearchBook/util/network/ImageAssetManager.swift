//
//  ImageAssetManager.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import UIKit

final class ImageAssetManager {
    static let shared = ImageAssetManager()
    
    private lazy var queue = DispatchQueue(label: "image-asset-manager", qos: .default)
    private let cacheMaxCount = 32
    
    private var cacheOrder = [URL]()
    private var cacheMap = [URL: UIImage]()
    
    func request(_ url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.queue.async {
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                if let cached = self.cacheMap[url] {
                    completion(cached)
                    return
                }
                
                let image = UIImage(data: data)
                
                if self.cacheOrder.count >= self.cacheMaxCount {
                    let removed = self.cacheOrder.removeFirst()
                    self.cacheMap[removed] = nil
                }
                
                self.cacheOrder.append(url)
                self.cacheMap[url] = image
                
                completion(image)
            }
        }
        task.resume()
    }
}
