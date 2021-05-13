//
//  LocationData.swift
//  Weather Check
//
//  Created by Onur Mavitas on 11.05.2021.
//

import Foundation

struct CityLocation: Codable {
    let title: String

    let location_type: String

    let woeid: Int

    let latt_long: String 
}
