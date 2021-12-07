//
//  RestaurantTableViewCell.swift
//  AllTrails
//
//  Created by David Para on 10/21/21.
//

import Combine
import UIKit
import MapKit

protocol RestaurantTableViewCellDelegate: AnyObject {
    func cell(_ restaurantTableViewCell: RestaurantTableViewCell, didMakeFavorite restaurant: Restaurant)
    func cell(_ restaurantTableViewCell: RestaurantTableViewCell, didRemoveFromFavorites restaurante: Restaurant)
}

class RestaurantTableViewCell: UITableViewCell {
    static let ID = "RestaurantTableViewCellID"
    static let NAME = "RestaurantTableViewCell"
    
    @IBOutlet private weak var restaurantImage: UIImageView!
    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ratingStackView: UIStackView!
    @IBOutlet private weak var ratingsCountLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var favoriteIcon: UIImageView!
    
    private let heartFill = UIImage(systemName: "heart.fill")
    private let heart = UIImage(systemName: "heart")
    private var subscriptions = Set<AnyCancellable>()
    
    private var rating = 0 {
        didSet {
            for i in 0..<5 {
                guard let star = (ratingStackView.subviews[i] as? UIImageView) else { return }
                star.image = UIImage(systemName: "star.fill")
                if i < rating {
                    star.tintColor = .systemYellow
                } else {
                    star.tintColor = .systemGray4
                }
            }
        }
    }
    
    weak var delegate: RestaurantTableViewCellDelegate?
    
    var isFavorite = false {
        didSet {
            if isFavorite {
                favoriteIcon.tintColor = .ATGreen
                favoriteIcon.image = heartFill
            } else {
                favoriteIcon.tintColor = .systemGray4
                favoriteIcon.image = heart
            }
        }
    }
    
    var restaurant: Restaurant? {
        didSet {
            guard let restaurant = restaurant else { return }
            nameLabel.text = restaurant.name
            ratingsCountLabel.text = "(\(restaurant.userRatingsTotal ?? 0))"
            rating = Int(restaurant.rating ?? 0)
            isFavorite = restaurant.isFavorite
            subtitleLabel.text = "\(restaurant.costRating) • Supporting Text"
            
            guard let photoReference = restaurant.photos?.first?.photoReference else { return }
            restaurantImage
                .loadImageFor(reference: photoReference)
                .sink(receiveCompletion: { _ in },
                      receiveValue: { _ in })
                .store(in: &subscriptions)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderColor = UIColor.systemGray4.cgColor
        borderView.layer.borderWidth = 2
        
        favoriteIcon.image = UIImage(systemName: "heart")
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleFavorite))
        favoriteIcon.addGestureRecognizer(tap)
        favoriteIcon.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurant = nil
        restaurantImage.image = nil
    }
    
    @objc private func toggleFavorite() {
        guard let restaurant = restaurant else {
            return
        }
        
        isFavorite.toggle()
        
        if isFavorite {
            delegate?.cell(self, didMakeFavorite: restaurant)
        } else {
            delegate?.cell(self, didRemoveFromFavorites: restaurant)
        }
    }
}
