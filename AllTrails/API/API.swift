//
//  API.swift
//  AllTrails
//
//  Created by David Para on 10/20/21.
//

import Foundation

enum APIKeys {
    static let places = "AIzaSyDQSd210wKX_7cz9MELkxhaEOUhFP0AkSk"
}

enum APIEndpoint: String {
    private static let path = "https://maps.googleapis.com/maps/api/place"
    
    case nearby = "nearbysearch"
    case photo
    
    func path() -> String {
        "https://maps.googleapis.com/maps/api/place/\(rawValue)/json"
    }
}
