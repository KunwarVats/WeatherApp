//
//  APIService.swift
//  RoadStat
//
//  Created by Kunwar Vats on 16/10/24.
//
import Foundation
import Combine

struct APIClient {
    
    func APIRequest<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T? {
        var urlComponents = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path.rawValue), resolvingAgainstBaseURL: false)!
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = endpoint.method.rawValue
        
        // Set up parameters for GET or POST requests
        if endpoint.method == .get, let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request.url = urlComponents.url
        } else if endpoint.method == .post, let parameters = endpoint.parameters {
            
            let formBodyString = parameters.map { "\($0)=\($1)" }.joined(separator: "&")
            let postData = formBodyString.data(using: .utf8)
            request.httpBody = postData
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted: \(context.debugDescription)")
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("CodingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("CodingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("CodingPath:", context.codingPath)
        } catch {
            print("Unknown error: \(error)")
        }
        
        return nil
    }
}
