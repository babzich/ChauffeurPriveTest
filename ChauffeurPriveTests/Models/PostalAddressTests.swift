//
//  PostalAddressTests.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ChauffeurPrive

final class PostalAddressTests: XCTestCase {
    func test_GivenAValidPlacemark_WhenInit_ThenTheObjectIsNotNil() {
        // GIVEN
        let placemark = correctPlacemark()
        
        // WHEN
        let address = PostalAddress(placemark: placemark)
        
        // THEN
        XCTAssertNotNil(address)
    }
    
    func test_GivenAPlacemarkWithoutLocation_WhenInit_ThenTheObjectIsNil() {
        // GIVEN
        let placemark = noLocationPlacemark()
        
        // WHEN
        let address = PostalAddress(placemark: placemark)
        
        // THEN
        XCTAssertNil(address)
    }
    
    func test_GivenAPlacemarkWithoutFormattedAddress_WhenInit_ThenTheObjectIsNil() {
        // GIVEN
        let placemark = noFormattedAddressPlacemark()
        
        // WHEN
        let address = PostalAddress(placemark: placemark)
        
        // THEN
        XCTAssertNil(address)
    }
    
    func test_GivenAValidPlacemark_WhenInit_ThenTheObjectCorrectlyCreated() {
        // GIVEN
        let placemark = correctPlacemark()
        
        // WHEN
        let address = PostalAddress(placemark: placemark)
        
        // THEN
        XCTAssertEqual(address?.coordinate, CLLocationCoordinate2D(latitude: 10, longitude: 20))
        XCTAssertEqual(address?.formattedAddress, "Rue des invalides, Paris, France")
    }
}

// MARK: Utils

extension PostalAddressTests {
    fileprivate func correctPlacemark() -> PlacemarkType {
        return MockPlacemark(location: CLLocation(latitude: 10, longitude: 20),
                             addressDictionary: ["FormattedAddressLines": ["Rue des invalides", "Paris, France"] ])
    }
    
    fileprivate func noLocationPlacemark() -> PlacemarkType {
        return MockPlacemark(location: nil,
                             addressDictionary: ["FormattedAddressLines": ["Paris, France"]])
    }
    
    fileprivate func noFormattedAddressPlacemark() -> PlacemarkType {
        return MockPlacemark(location: CLLocation(latitude: 10, longitude: 20),
                             addressDictionary: ["country": ["Paris, France"]])
    }
}
