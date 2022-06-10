//
//  ImageDownloader.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    
    let session: URLSession
    init(session: URLSession) {
        self.session = session
    }
    
    func donwnload( _ url: URL, callbackQueue: CallbackQueue = .main, completion: @escaping (Result<UIImage, Error>) -> Void
        )
    {
//        print("started download \(url)")
        
        session.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                callbackQueue.execute { completion(.failure(error ?? ResponseError.nilData))}
                
                return
            }
            
            guard (response as? HTTPURLResponse) != nil else {
                
                callbackQueue.execute { completion(.failure(error ?? ResponseError.nonHTTPResponse))}
                
                return
            }
            
            print("image data:\(data)")
            
            if let image = UIImage(data: data) {
                callbackQueue.execute { completion(.success(image)) }
            }
            else {
                print("parse failed:\(data)")

                    callbackQueue.execute { completion(.failure(error ?? ResponseError.dataParsingFailed(data, nil))) }
                }
            }.resume()
    }
}
