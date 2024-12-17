//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Kunwar Vats on 16/12/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var currentWeather: Weather?
    @Published var searchQuery: String = ""
    @Published var isSearching: Bool = false

    @Published var searchResults: [City] = []
    @Published var searchResultsWeather: [String: Weather] = [:]


    private var cancellables = Set<AnyCancellable>()

    func fetchWeather(for city: String) async {
        // Simulate API call to fetch weather data
        // You can replace this with an actual API request
        
        if let result = try? await NetworkService.shared.currentWeather(KeyConstants.weatherAPIKey.rawValue, city)
        {
            await MainActor.run {
                
                if isSearching
                {
                    searchResultsWeather[city] = result
                }
                else
                {
                    currentWeather = result
                }
            }
        }
    }
    
    func searchCity() async {
        // Simulate API call to search cities
        // You can replace this with an actual API request
        
        if let results = try? await NetworkService.shared.cityAutoComplete(KeyConstants.weatherAPIKey.rawValue, searchQuery) {
            // Ensure UI updates are dispatched on the main thread
            await MainActor.run {
                searchResults = results
            }
            
            for city in results {
                await fetchWeather(for: city.name)
            }
        }
    }
    
    func loadCurrentWeather() async
    {
        if let city = UserDefaultsHelper.getCity() {
            
            if currentWeather?.location.name != city
            {
                await fetchWeather(for: city)
            }
        }
    }
}
