//
//  Webservice.swift
//  LucsonAssignment
//
//  Created by Ashwinkumar Mangrulkar on 26/06/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import Foundation
import Alamofire
import Reachability

class Webservice: NSObject {
    
    static let sharedInstance = Webservice()
    
    /// Function to check Imternet Connection available or not
    ///
    /// - Returns: return bool value
    func isInternetAvailable()->Bool
    {
        //declare this property where it won't go out of scope relative to your listener
        let reachability = Reachability()!
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                return true
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    /// Web Servce to get Routes Coordinates
    ///
    /// - Parameters:
    ///   - destinationLat: Destination Latitude
    ///   - destinationLong: Destination Longitude
    ///   - withCompletionHandler: Response
    func webServiceGetRouteCoordinates(_ parameter:MapModel, _ withCompletionHandler:@escaping (_ success:Bool, _ responseDictionary:AnyObject?, _ error:NSError?)->Void)
    {
        //--Checking internet
        if isInternetAvailable()==false
        {
            withCompletionHandler(false, nil, nil)
            return
        }
        
        let url = String(format:"%@&origin=%f,%f&destination=%f,%f&key=%@", Url_Get_Route, parameter.sourceLatitude!, parameter.sourceLongitude!, parameter.destinationLatitude!, parameter.destinationLongitude!, keyGoogleMap)
//        print("url \(url)")
        
        Alamofire.request(url, parameters: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    //                    //print("JSON: \(JSON)")
                    withCompletionHandler(true, JSON as AnyObject?,response.result.error as NSError?)
                }else
                {
                    withCompletionHandler(false, nil,response.result.error as NSError?)
                }
        }
    }
}
