//
//  NetworkConstants.swift
//  RoadStat
//
//  Created by Kunwar Vats on 17/10/24.
//
import Foundation

//API constants
enum APIUrls: String {
    
    case base = "http://api.weatherapi.com/v1/"
    case currentWeather = "current.json"
    case cityAutoComplete = "search.json"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error {
    case invalidResponse
    case invalidData
    case badUrl
}
