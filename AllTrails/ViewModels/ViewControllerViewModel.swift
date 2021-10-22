//
//  ViewControllerViewModel.swift
//  AllTrails
//
//  Created by David Para on 10/21/21.
//

import Combine
import CoreLocation
import Foundation

class ViewControllerViewModel {
    private(set) var favoritesService: FavoritesService
    
    private var service: RestaurantsService
    private var subscriptions = Set<AnyCancellable>()
    
    var restaurants = CurrentValueSubject<Restaurants, RestaurantsService.ServiceError>(Restaurants())
    
    init(service: RestaurantsService = .init(),
         favoritesService: FavoritesService = .init()) {
        self.service = service
        self.favoritesService = favoritesService
    }
    
    func loadNearbyRestaurants(for location: CLLocation, radius: Int, searchKeyword: String? = nil) {
        service.fetchRestaurants(latitude: location.coordinate.longitude, longitude: location.coordinate.latitude, radius: radius, searchKeyword: searchKeyword)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.restaurants.send(completion: completion)
                    print(error)
                }
            } receiveValue: { [weak self] restaurants in
                self?.restaurants.send(restaurants)
            }
            .store(in: &subscriptions)
    }
}
