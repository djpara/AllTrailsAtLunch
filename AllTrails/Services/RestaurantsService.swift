//
//  RestaurantsService.swift
//  AllTrails
//
//  Created by David Para on 10/20/21.
//

import Alamofire
import Combine
import UIKit

class RestaurantsService {
    enum ServiceError: Error {
        case requestError(_ error: Error?)
        case imageRequestError(_ error: Error?)
    }
    
    private var nearby = "/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&key=\(APIKeys.places)"
    
    func fetchRestaurants(latitude: Double, longitude: Double, searchKeyword: String?) -> AnyPublisher<Restaurants, ServiceError> {
        Future { promise in
            var parameters = [
                "location": "\(longitude),\(latitude)",
                "radius": "500",
                "types": "food",
                "key": APIKeys.places
            ]
            
            if let searchKeyword = searchKeyword {
                parameters.updateValue("\(searchKeyword)", forKey: "name")
            }
            
            AF.request(APIEndpoint.nearby.path(),
                                     method: .get,
                                     parameters: parameters)
                .validate()
                .responseDecodable(of: Restaurants.self) { response in
                    guard let restaurants = response.value else {
                        promise(.failure(.requestError(response.error)))
                        return
                    }
                    promise(.success(restaurants))
                }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchImageFor(reference: String, imageView: UIImageView) -> AnyPublisher<(), ServiceError> {
        Deferred {
            Future { promise in
                let parameters: [String: Any] = [
                    "max_width": 100,
                    "photo_reference": reference,
                    "key": APIKeys.places
                ]
                AF.request(APIEndpoint.photo.path(),
                           method: .get,
                           parameters: parameters)
                    .validate()
                    .response(queue: .global(qos: .background)) { response in
                        guard let data = response.data else {
                            promise(.failure(.imageRequestError(response.error)))
                            return
                        }
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            imageView.image = image
                            promise(.success(()))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
