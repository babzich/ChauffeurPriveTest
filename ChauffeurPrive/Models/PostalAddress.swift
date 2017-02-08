//
//  PostalAddress.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import CoreLocation

protocol Persistable {
    func toDictionary() -> [String: Any]
    init?(with dictionary: [String: Any])
}

protocol PlacemarkType {
    var location: CLLocation? { get }
    var addressDictionary: [AnyHashable : Any]? { get }
}

extension CLPlacemark: PlacemarkType { }

struct PostalAddress {
    let formattedAddress: String
    let coordinate: CLLocationCoordinate2D
    
    // MARK: Initializer
    
    init?(placemark: PlacemarkType) {
        guard
            let location = placemark.location,
            let address = placemark.addressDictionary?["FormattedAddressLines"] as? [String]
        else { return nil }
        
        self.formattedAddress = address.joined(separator: ", ")
        self.coordinate = location.coordinate
    }
}

// MARK: Equatable

extension PostalAddress: Equatable {
    public static func ==(lhs: PostalAddress, rhs: PostalAddress) -> Bool {
        return lhs.formattedAddress == rhs.formattedAddress
            && lhs.coordinate.latitude == rhs.coordinate.latitude
            && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

// MARK: Persistable

extension PostalAddress: Persistable {
    enum Keys {
        static let formattedAddress = "formattedAddress"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    init?(with dictionary: [String : Any]) {
        guard let address = dictionary[Keys.formattedAddress] as? String,
            let latitude = dictionary[Keys.latitude] as? CLLocationDegrees,
            let longitude = dictionary[Keys.longitude] as? CLLocationDegrees
            else { return nil }
        
        self.formattedAddress = address
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func toDictionary() -> [String:Any] {
        return [
            Keys.formattedAddress: formattedAddress,
            Keys.latitude: coordinate.latitude,
            Keys.longitude: coordinate.longitude
        ]
    }
}


