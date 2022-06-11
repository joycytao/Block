//
//  ImageDownloader.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit

public protocol ImageDownload {
    
    func donwnload( _ url: URL, callbackQueue: CallbackQueue, completion: @escaping (Result<UIImage, Error>) -> Void )
}

public extension ImageDownload {
    
    func donwnload( _ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void ) {
        self.donwnload(url, callbackQueue: .main, completion: completion)
    }
}


extension HTTPClient: ImageDownload {
    
    public func donwnload( _ url: URL, callbackQueue: CallbackQueue, completion: @escaping (Result<UIImage, Error>) -> Void)
    {
        
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
