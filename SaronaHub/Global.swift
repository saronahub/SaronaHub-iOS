//
//  Global.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 8.1.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit

let GreenColor = UIColor(red: 151/255, green: 214/255, blue: 218/255, alpha: 1)

let UserDefaults: Foundation.UserDefaults = Foundation.UserDefaults.standard

public enum RequestMethod {
    case get
    case post
}

public func request(method: RequestMethod, _ endpoint: String, with dict: [String : Any?]?, _ complition: ((_ data: JSON) -> Void)?, _ errorHandle: ((_ error: Error) -> Void)?)  -> URLSessionDataTask {
    let Server_URL = URL(string: "http://saronahub.eu-west-2.elasticbeanstalk.com/\(endpoint)")!
    var request = URLRequest(url: Server_URL)
    switch method {
    case .get:
        request.httpMethod = "GET"
        break
    case .post:
        request.httpMethod = "POST"
        break
    }
    // insert json data to the request
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    if let token = UserDefaults.string(forKey: "token") {
        request.addValue(token, forHTTPHeaderField: "authorization")
    }
    if let dict = dict {
        request.httpBody = try? JSONSerialization.data(withJSONObject: dict, options: [])
    }
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
        if let errorHandle = errorHandle, let error = error {
            errorHandle(error)
        } else if let complition = complition, let data = data {
            complition(JSON(data: data))
        }
    }
    task.resume()
    return task
}
