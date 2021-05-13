//
//  ViewController.swift
//  Weather Check
//
//  Created by Onur Mavitas on 10.05.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {


    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nearbyCitiesButton: UIButton!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    var nearbyCities = Array<CityModel>()
    var forecasts = Array<WeatherModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        //register the nib file to the tableview
        let nib = UINib(nibName: "MainTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MainTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchTextField.delegate = self
        
        nearbyCitiesButton.layer.cornerRadius = 20
        nearbyCitiesButton.layer.borderWidth = 0.5
        nearbyCitiesButton.layer.borderColor = UIColor.blue.cgColor
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        //use searchTextField.text to get the weather of that city
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (searchTextField.text != "") {
            return true
        } else {
            searchTextField.placeholder = "Provide a city name"
            return false
        }
    }
    
    @IBAction func nearbyPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCities", sender: self)
    }
    
    @IBAction func locationPressed(_ sender: Any) {
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        searchTextField.endEditing(true)
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
