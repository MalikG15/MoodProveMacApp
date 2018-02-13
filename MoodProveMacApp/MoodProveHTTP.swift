//
//  MoodProveHTTP.swift
//  MoodProve
//
//  Created by Malik Graham on 2/12/18.
//  Copyright © 2018 Malik Graham. All rights reserved.
//

import Cocoa

class MoodProveHTTP: NSObject {
    
    
    static func getRequest(urlRequest: String) -> String {
        let url = URL(string: urlRequest)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if (error != nil) {
                print("There was an error submitting a GET request for url: " + urlRequest)
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    // For count
                    print(json as NSDictionary)
                    
                } catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
        return ""
    }

}
