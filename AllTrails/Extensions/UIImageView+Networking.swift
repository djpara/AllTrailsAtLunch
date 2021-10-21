//
//  UIImageView+Networking.swift
//  AllTrails
//
//  Created by David Para on 10/21/21.
//

import Alamofire
import Combine
import UIKit

extension UIImageView {
    func loadImageFor(reference: String, userService service: RestaurantsService = .init()) -> AnyPublisher<(), RestaurantsService.ServiceError> {
        service.fetchImageFor(reference: reference, imageView: self)
    }
}
