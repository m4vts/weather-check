//
//  CitiesViewController.swift
//  Weather Check
//
//  Created by Onur Mavitas on 10.05.2021.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherManagerDelegate {

    
    @IBOutlet var tableView: UITableView!
    
    var nearbyCities = Array<CityModel>()
    var weatherDetail = Array<WeatherDetail>()
    var weatherManager = WeatherManager()
    fileprivate var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register the nib file to the tableview
        let nib = UINib(nibName: "CitiesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CitiesTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        weatherManager.delegate = self
        
        
    }
    
    //Tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesTableViewCell", for: indexPath) as! CitiesTableViewCell
        cell.nameLabel.text = nearbyCities[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherManager.fetchTemp(with: nearbyCities[indexPath.row].woeid)
        selectedRow = indexPath.row
    }
    
    
    //MARK: - WeatherManagerDelegate
    
    func didUpdateCities(_ weatherManager: WeatherManager, cities: [CityModel]) {
        
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: [WeatherDetail]) {
        weatherDetail = weather
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToDetail", sender: self)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }
        detailVC.weatherDetail = weatherDetail
        detailVC.cityName = nearbyCities[selectedRow!].title
    }
}
