//
//  WebServiceManager.swift
//  MVVMDemo
//
//  Created by Sagar Kalathil on 24/09/20.
//  Copyright © 2020 Sagar Kalathil. All rights reserved.
//

import Foundation

class WebServiceManager :  NSObject {
    
    func callGetApi(strUrl : String, completion : @escaping (Data?,Bool) -> ()){
        let url = URL(string: strUrl)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            print("Task completed")

            guard let data = data, error == nil else {
                print(error?.localizedDescription)
                completion(nil,false)
                return
            }
            completion(data,true)
            /*
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data) as? NSDictionary {
                    var arrData = jsonResult.value(forKey: "data") as! NSArray
                    let dt = NSKeyedArchiver.archivedData(withRootObject: arrData)
                    completion(dt,true)
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }*/
        }

        task.resume()
        
        
        
        /*
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                
                let arrList = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                print(arrList)
                completion(arrList)
            }
        }.resume()*/
    }
}
