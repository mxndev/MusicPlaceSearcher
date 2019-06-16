//
//  NetworkResult.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 17/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation

enum NetworkResultCode: Int
{
    case BadRequest = 400
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case JSONDecodingError = 0
}

enum NetworkResult<T> {
    case success(T)
    case failure(NetworkResultCode)
}

protocol NetworkResultType { }
extension Data: NetworkResultType {}

extension NetworkResult where T: NetworkResultType {
    
    func decodeData<U: Codable>() -> NetworkResult<U> {
        switch self {
        case .success(let data):
            do {
                guard let data = data as? Data else {
                    return .failure(.JSONDecodingError)
                }
                
                let object: U = try JSONDecoder().decode(U.self, from: data)
                return .success(object)
            } catch let jsonError {
                print("Error during JSON decoding: ", jsonError)
                return .failure(.JSONDecodingError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
