//
//  NetworkEnums.swift
//  RoadStat
//
//  Created by Kunwar Vats on 17/10/24.
//
import Foundation

//Login endpoint
enum APIEndpoints: APIEndpoint {
    case currentWeather(_ key: String,_ q: String,_ aqi: String?)
    case cityAutoComplete(_ key: String,_ q: String)

    var baseURL: URL {
        return URL(string: APIUrls.base.rawValue)!
    }
    
    var path: APIUrls {
        switch self {
        case .currentWeather(_, _, _):
            return .currentWeather
        case .cityAutoComplete(_, _):
            return .cityAutoComplete
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
            
        case .currentWeather(let key, let q, let aqi):
            return [
                "key": key,
                "q"  : q,
                "aqi": aqi ?? "no"
            ]
        case .cityAutoComplete(let key, let q):
            return [
                "key": key,
                "q"  : q,
            ]
        }
    }
}
