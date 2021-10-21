//
//  ViewController.swift
//  AllTrails
//
//  Created by David Para on 10/20/21.
//

import Combine
import CoreLocation
import MapKit
import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var toggleListMapButton: UIButton!
    @IBOutlet private weak var mapView: MKMapView!
    
    private var subscriptions = Set<AnyCancellable>()
    private var listButtonTitle = NSLocalizedString("List", comment: "A list view of search results")
    private var mapButtonTitle = NSLocalizedString("Map", comment: "A map view of search results")
    
    private var showMapView = true {
        didSet {
            if showMapView {
                tableView.isHidden = true
                mapView.isHidden = false
                toggleListMapButton.setImage(listIcon, for: .normal)
                toggleListMapButton.setTitle(listButtonTitle, for: .normal)
            } else {
                mapView.isHidden = true
                tableView.isHidden = false
                toggleListMapButton.setImage(mapPin, for: .normal)
                toggleListMapButton.setTitle(mapButtonTitle, for: .normal)
            }
        }
    }
    
    private var magnifyingGlass: UIImage? = {
        let image = UIImage(systemName: "magnifyingglass")
        return image?.withTintColor(.ATGreen)
    }()
    
    private var mapPin: UIImage? = {
        let image = UIImage(systemName: "mappin")
        return image?.withTintColor(.ATGreen)
    }()
    
    private var listIcon: UIImage? = {
        let image = UIImage(systemName: "list.bullet")
        return image?.withTintColor(.ATGreen)
    }()
    
    private lazy var magnifyingGlassView: UIImageView = {
        let view = UIImageView(image: magnifyingGlass)
        view.tintColor = .ATGreen
        return view
    }()
    
    private var pins = [MKPointAnnotation]()
    
    var viewModel = ViewControllerViewModel()
    var locationManager: CLLocationManager = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        configureLocationTracking()
        configureMapView()
        configureTableView()
        subscribe(to: viewModel.restaurants)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadNearbyRestaurants()
    }

    private func configureSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderColor = UIColor.ATGray.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = 8
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.leftView = nil
        searchBar.searchTextField.rightViewMode = .always
        searchBar.searchTextField.rightView = magnifyingGlassView
        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()
        searchBar.delegate = self
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissSearchKeyboard))
        toolbar.items = [space, doneButton]
        toolbar.sizeToFit()
        searchBar.inputAccessoryView = toolbar
    }
    
    private func configureLocationTracking() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func configureMapView() {
        mapView.delegate = self
    }
    
    private func configureTableView() {
        let nib = UINib(nibName: RestaurantTableViewCell.NAME, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: RestaurantTableViewCell.ID)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
    }
    
    private func showUserLocation() {
        mapView.showsUserLocation = true
    }
    
    private func subscribe(to restaurantsPublisher: CurrentValueSubject<Restaurants, RestaurantsService.ServiceError>) {
        viewModel.restaurants
            .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print(error)
            }
        }, receiveValue: { [weak self] restaurants in
            guard let self = self else { return }
            self.clearPins()
            self.tableView.reloadData()
            restaurants.all.forEach { restaurant in
                self.addPin(for: restaurant)
            }
        })
            .store(in: &subscriptions)
    }
    
    private func loadNearbyRestaurants() {
        guard let location = locationManager.location else { return }
        viewModel.loadNearbyRestaurants(for: location, searchKeyword: searchBar.text)
    }
    
    private func addPin(for restaurant: Restaurant) {
        let location = restaurant.geometry.location.toCLLocation()
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        
        DispatchQueue.main.async {
            self.pins.append(pin)
            self.mapView.addAnnotation(pin)
        }
    }
    
    private func clearPins() {
        mapView.removeAnnotations(pins)
        pins.removeAll()
    }
    
    @objc private func dismissSearchKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    @IBAction private func didTapListMapButton(_ sender: Any) {
        showMapView.toggle()
    }
    
    func startTracking() {
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation,
                                                latitudinalMeters: 500,
                                                longitudinalMeters: 500)
            mapView.setRegion(viewRegion, animated: false)
        }
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func refresh() {
        guard !viewModel.restaurants.value.all.isEmpty else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
