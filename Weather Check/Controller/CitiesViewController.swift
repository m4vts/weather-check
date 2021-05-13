//
//  CitiesViewController.swift
//  Weather Check
//
//  Created by Onur Mavitas on 10.05.2021.
//

import UIKit
import Network

class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherManagerDelegate {

    
    @IBOutlet var tableView: UITableView!
    
    var nearbyCities = Array<CityModel>()
    var weatherDetail = Array<WeatherDetail>()
    var weatherManager = WeatherManager()
    fileprivate var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verifyConnection()
        
        //register the nib file to the tableview
        let nib = UINib(nibName: "CitiesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CitiesTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        weatherManager.delegate = self
        
        
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
    
   //MARK: - UITableViewDelegate
    
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
