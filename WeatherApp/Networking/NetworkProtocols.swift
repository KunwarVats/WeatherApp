//
//  NetworkProtocols.swift
//  RoadStat
//
//  Created by Kunwar Vats on 17/10/24.
//

import Foundation
import Combine

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: APIUrls { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}
