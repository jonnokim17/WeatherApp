//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jonathan Kim on 2/27/18.
//  Copyright © 2018 Jonathan Kim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!

    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        handleOfflineMode()
        setupUI()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        gestureRecognizer.numberOfTapsRequired = 2
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    private func setupUI() {
        navigationItem.title = "Weather App"
        UINavigationBar.appearance().prefersLargeTitles = true
    }

    private func handleOfflineMode() {
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
        } else {
            print("Internet Connection not Available!")
            guard let offlineDict = UserDefaults.standard.object(forKey: "offlineData") as? [String: Any] else { return }

            guard
                let lat = offlineDict["latitude"] as? Double,
                let long = offlineDict["longitude"] as? Double,
                let currentTemp = offlineDict["currentTemperature"] as? Double,
                let tempSummary = offlineDict["currentSummary"] as? String,
                let weatherIcon = offlineDict["weatherIcon"] as? String,
                let cityName = offlineDict["city"] as? String,
                let countryName = offlineDict["country"] as? String
                else { return }

            self.cityLabel.text = "\(cityName), \(countryName)"
            self.temperatureLabel.text = "\(Int(currentTemp)) °F"
            self.weatherDescriptionLabel.text = tempSummary
            self.weatherIconImageView.image = UIImage(named: weatherIcon)

            let span = MKCoordinateSpanMake(10, 10)
            let myLocation = CLLocationCoordinate2DMake(lat, long)
            let region = MKCoordinateRegionMake(myLocation, span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            mapView.addAnnotation(annotation)
        }
    }

    @objc func handleDoubleTap(_ gestureReconizer: UITapGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)

        Weather.forecast(withLocation: coordinate) { (results: [Weather]?) in
            guard let forecastData = results else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailController = storyboard.instantiateViewController(withIdentifier :"DetailViewController") as? DetailViewController else { return }
            detailController.forecastData = forecastData
            detailController.coordinate = coordinate
            let navController = UINavigationController(rootViewController: detailController)
            self.present(navController, animated: true)
        }
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


