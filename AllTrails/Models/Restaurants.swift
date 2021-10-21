//
//  Restaurants.swift
//  AllTrails
//
//  Created by David Para on 10/20/21.
//

import Foundation

class Restaurants: Codable {
    enum CodingKeys: String, CodingKey {
        case nextPageToken = "next_page_token"
        case all = "results"
    }
    
    var nextPageToken: String?
    var all: [Restaurant]
    
    init(nextPageToken: String? = nil, all: [Restaurant] = []) {
        self.nextPageToken = nextPageToken
        self.all = all
    }
}
