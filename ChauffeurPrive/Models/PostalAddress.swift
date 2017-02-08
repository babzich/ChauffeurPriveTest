//
//  PostalAddress.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import CoreLocation

protocol PlacemarkType {
    var location: CLLocation? { get }
    var addressDictionary: [AnyHashable : Any]? { get }
}

extension CLPlacemark: PlacemarkType { }

struct PostalAddress {
    private let placemark: PlacemarkType
    let formattedAddress: String
    let coordinate: CLLocationCoordinate2D
    
    // MARK: Initializer
    
    init?(placemark: PlacemarkType) {
        guard
            let location = placemark.location,
            let address = placemark.addressDictionary?["FormattedAddressLines"] as? [String]
        else { return nil }
        
        self.placemark = placemark
        self.formattedAddress = address.joined(separator: ", ")
        self.coordinate = location.coordinate
    }
}
