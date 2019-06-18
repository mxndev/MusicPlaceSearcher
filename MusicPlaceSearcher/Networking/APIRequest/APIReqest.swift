//
//  APIReqest.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 17/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

typealias Parameters = [String: String]

enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIRequestBase {
    var method: Method { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

struct APIRequest: APIRequestBase {
    let method: Method
    let path: String
    let parameters: Parameters?
}

extension APIRequest {
    
    init(method: Method, endpoint: String, parameters: Parameters? = nil)
    {
        let path = Constants.Networking.API.host + "/" + Constants.Networking.API.version + "/" + endpoint
        
        self.init(method: method, path: path, parameters: parameters)
    }
}
