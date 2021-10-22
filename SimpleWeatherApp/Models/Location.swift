//
//  Location.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-07-25.
//

import Foundation

struct Location {
    let woeid: Int
    let title: String
    let locationType: String // should be enum?
    let latLong: (Double, Double) // should be CLLocationCoordinate?
}

struct Weather: Decodable {
    let woeid: Int
    let title: String
}
