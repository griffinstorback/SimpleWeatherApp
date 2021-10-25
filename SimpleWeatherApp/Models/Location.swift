//
//  Location.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-07-25.
//

import Foundation

struct Location {
    let title: String
    let locationType: String // should be enum?
    let woeid: Int
    let latLongString: String
    let latLong: (Double,Double)
}

extension Location: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case latLongString = "latt_long"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        locationType = try container.decode(String.self, forKey: .locationType)
        woeid = try container.decode(Int.self, forKey: .woeid)
        
        latLongString = try container.decode(String.self, forKey: .latLongString)
        latLong = Location.createLatLongFromCommaSeparatedString(latLongString: self.latLongString)
    }
    
    static func createLatLongFromCommaSeparatedString(latLongString: String) -> (Double, Double) {
        let latLongStrings = latLongString.components(separatedBy: ",")
        guard let lat = Double(latLongStrings[0]), let long = Double(latLongStrings[1]) else {
            return (0.0, 0.0)
        }
        
        return (lat, long)
    }
}

struct Weather: Decodable {
    let woeid: Int
    let title: String
}
