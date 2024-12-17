//
//  HomeView.swift
//  WeatherApp
//
//  Created by Kunwar Vats on 16/12/24.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            // Search Bar outside of ZStack
            HStack {
                TextField("Search for a city", text: $viewModel.searchQuery)
                    .submitLabel(.search)
                    .padding(10)
                    .background(bgColor)
                    .cornerRadius(10)
                    .focused($isFocused)
                    .onSubmit {
                        // This will be called when the "Search" key is pressed
                        viewModel.isSearching = true
                        Task {
                            await viewModel.searchCity()
                        }
                    }

                if viewModel.isSearching {
                    Button("Cancel") {
                        viewModel.searchQuery = ""
                        viewModel.isSearching = false
                    }
                }

                if !viewModel.isSearching {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 40)

            ZStack {
                // 1st View: Original Weather Info (Visible by default)
                if !viewModel.isSearching {
                    VStack {
                        AsyncImage(url: URL(string: viewModel.currentWeather?.current.condition.icon ?? "")) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        } placeholder: {
                            ProgressView()
                        }
                        .padding(.top, 20)

                        Text(viewModel.currentWeather?.location.name ?? "")
                            .font(.system(size: 42, weight: .bold))
                            .padding(.top, 10)

                        Text(String(format: "%.0f\u{00B0}", viewModel.currentWeather?.current.tempC ?? 0))
                            .font(.system(size: 70, weight: .medium))
                            .padding(.top, 5)

                        HStack {
                            WeatherDetailView(titleText: "Humidity", valueText: String(format: "%.1f", viewModel.currentWeather?.current.humidity ?? 0))
                            WeatherDetailView(titleText: "UV Index", valueText: String(format: "%.0f", viewModel.currentWeather?.current.uv ?? 0))
                            WeatherDetailView(titleText: "Feels Like", valueText: String(format: "%.0f\u{00B0}", viewModel.currentWeather?.current.feelslikeC ?? 0))
                        }
                        .background(bgColor)
                        .cornerRadius(20)
                    }
                }

                // 2nd View: Weather Card (when search bar is tapped)
                if viewModel.isSearching {
                    ScrollView {
                        ForEach(viewModel.searchResults.indices, id: \.self) { index in

                            let city = viewModel.searchResults[index]
                            let weather = viewModel.searchResultsWeather[city.name]
                            
                            VStack {
                                HStack {
                                    VStack(alignment: .leading, content: {
                                        
                                        Text("\(city.name), \(city.country)")
                                            .font(.system(size: 24, weight: .bold))
                                        Text(String(format: "%.0f\u{00B0}", weather?.current.tempC ?? 0))
                                            .font(.system(size: 24, weight: .medium))
                                    })
                                    .padding(.leading, 20)
                                    Spacer()
                                    
                                    AsyncImage(url: URL(string: weather?.current.condition.icon ?? "")) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                .padding()
                                .background(bgColor)
                                .cornerRadius(10)
                            }
                            .padding(.top, 20)
                            .onTapGesture {
                                viewModel.isSearching = false
                                viewModel.searchQuery = ""
                                viewModel.currentWeather = weather
                                UserDefaultsHelper.saveCity(city.name)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .onChange(of: isFocused, { oldValue, newValue in
            if newValue {
                viewModel.isSearching = true
            }
        })
        .onAppear {
            
            Task {
                await viewModel.loadCurrentWeather()
            }
        }
        
        Spacer()
    }
}

struct WeatherDetailView: View {
    
    var titleText: String
    var valueText: String
    
    var body: some View {
        VStack {
            Text(titleText)
                .foregroundStyle(Color.gray)
            Text(valueText)
                .font(.subheadline)
        }
        .padding()
    }
}
