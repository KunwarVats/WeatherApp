//
//  NetworkService.swift
//  RoadStat
//
//  Created by Kunwar Vats on 17/10/24.
//
import Foundation
import Combine

class NetworkService {
    
    static let shared = NetworkService()

    // Private initializer to prevent creating new instances
    private init() {
        // Initialization code
    }
    private let apiClient = APIClient()
    
    func currentWeather(_ key: String, _ city: String) async throws -> Weather? {
        
        let weatherResponse: Weather? = try await apiClient.APIRequest(APIEndpoints.currentWeather(key, city, nil))
        return weatherResponse
    }
    
    func cityAutoComplete(_ key: String, _ query: String) async throws -> [City]? {
        
        let cityResponse: [City]? = try await apiClient.APIRequest(APIEndpoints.cityAutoComplete(key, query))
        return cityResponse
    }
}

