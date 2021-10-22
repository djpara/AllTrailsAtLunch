//
//  Restaurant.swift
//  AllTrails
//
//  Created by David Para on 10/20/21.
//

import CoreLocation
import Foundation

class Restaurant: Codable {
    enum Cost: Int {
        case affordable = 1
        case fair
        case expensive
        
        var stringValue: String {
            switch self {
            case .affordable: return "$"
            case .fair: return "$$"
            case .expensive: return "$$$"
            }
        }
    }
    
    enum Stars: Int {
        case one = 1
        case two
        case three
        case four
        case five
        
        var stringValue: String {
            switch self {
            case .one: return "★☆☆☆☆"
            case .two: return "★★☆☆☆"
            case .three: return "★★★☆☆"
            case .four: return "★★★★☆"
            case .five: return "★★★★★"
            }
        }
    }
    
    struct Geometry: Codable {
        struct Location: Codable {
            var lat: Double
            var lng: Double
            
            func toCLLocation() -> CLLocation {
                return CLLocation(latitude: lat, longitude: lng)
            }
        }

        var location: Location
    }

    struct Photo: Codable {
        enum CodingKeys: String, CodingKey {
            case photoReference = "photo_reference"
        }
        
        var photoReference: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case name
        case rating
        case priceLevel = "price_level"
        case userRatingsTotal = "user_ratings_total"
        case geometry
        case photos
    }
    
    var id: String
    var name: String
    var rating: Double?
    var priceLevel: Int?
    var userRatingsTotal: Int?
    var geometry: Geometry
    var photos: [Photo]?
    
    var isFavorite = false
    var costRating: String {
        guard let priceLevel = priceLevel,
              let cost = Cost(rawValue: priceLevel) else {
                  return "$"
              }
        return cost.stringValue
    }
    var starRating: String {
        guard let rating = rating,
            let starRating = Stars(rawValue: Int(rating)) else {
            return "★☆☆☆☆"
        }
        return starRating.stringValue
    }
}
