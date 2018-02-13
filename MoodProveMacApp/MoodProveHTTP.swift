//
//  MoodProveHTTP.swift
//  MoodProve
//
//  Created by Malik Graham on 2/12/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa
import SwiftyJSON

class MoodProveHTTP: NSObject {

    
    
    static func getRequest(urlRequest: String) -> JSON {
        let url = URL(string: urlRequest)!
        var responseJSON: JSON = JSON.null
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if (error != nil) {
                print("There was an error submitting a GET request for url: " + urlRequest)
            } else {
                if (data != nil) {
                    responseJSON = JSON(data: data!)
                }
                semaphore.signal()
            }
        }).resume()
         _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return responseJSON
    }

}
