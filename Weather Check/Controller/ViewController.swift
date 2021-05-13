//
//  ViewController.swift
//  Weather Check
//
//  Created by Onur Mavitas on 10.05.2021.
//

import UIKit
import CoreLocation
import Network

class ViewController: UIViewController, WeatherManagerDelegate {



    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nearbyCitiesButton: UIButton!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    var nearbyCities = Array<CityModel>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verifyConnection()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        //register the nib file to the tableview
        let nib = UINib(nibName: "MainTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MainTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.layer.cornerRadius = 10
        
        nearbyCitiesButton.layer.cornerRadius = 16
    
    }
    
    func verifyConnection() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in

            if path.status != .satisfied {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Oops!", message: "There is a problem with your internet connection", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func nearbyPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCities", sender: self)
    }
    
    
//MARK: - WeatherManagerDelegate
    
    func didUpdateCities(_ weatherManager: WeatherManager, cities: [CityModel]) {
        nearbyCities = cities
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.nearbyCitiesButton.isHidden = false
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: [WeatherDetail]) {
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        cell.nameLabel.text = nearbyCities[indexPath.row].title
        return cell
    }
}

//MARK: - Navigation

extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let citiesVC = segue.destination as? CitiesViewController else { return }
        citiesVC.nearbyCities = nearbyCities
    }
}
