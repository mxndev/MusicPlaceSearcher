//
//  URLSessionService.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 17/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation

class URLSessionService {
    
    static let instance: URLSessionService = URLSessionService()
    
    private let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
    
    func executeURLRequest(apiRequest: APIRequestBase, completionHandler: @escaping (NetworkResult<Data>) -> Void) {
        
        var request: URLRequest
        if (apiRequest.method == .get) {
            request = URLRequest(url: URL(string: apiRequest.path + buildQueryString(fromDictionary: apiRequest.parameters!))!)
        } else {
            request = URLRequest(url: URL(string: apiRequest.path)!)
        }
        request.httpMethod = apiRequest.method.rawValue

        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if let data = data, httpResponse.statusCode < 300
                {
                    completionHandler(.success(data))
                }
                completionHandler(.failure(NetworkResultCode(rawValue: httpResponse.statusCode) ?? .APIError))
            }
        })
        task.resume()
    }
    
    func buildQueryString(fromDictionary parameters: [String:String]) -> String {
        var urlVars:[String] = []
        
        for (k, value) in parameters {
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                urlVars.append(k + "=" + encodedValue)
            }
        }
        
        return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
    }
}
