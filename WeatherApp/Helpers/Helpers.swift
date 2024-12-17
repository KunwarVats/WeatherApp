//
//  Helpers.swift
//  WeatherApp
//
//  Created by Kunwar Vats on 16/12/24.
//
import Foundation

struct UserDefaultsHelper {
    
    static func saveCity(_ city: String) {
        let defaults = UserDefaults.standard
        defaults.set(city, forKey: KeyConstants.savedCity.rawValue)
    }
    
    static func getCity() -> String? {
        let defaults = UserDefaults.standard
        if let city = defaults.string(forKey: KeyConstants.savedCity.rawValue)
        {
            return city
        }
        
        return nil
    }

}
