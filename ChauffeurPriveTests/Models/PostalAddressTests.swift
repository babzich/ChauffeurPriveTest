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

// MARK: Equatable

extension PostalAddressTests {
    func test_GivenToEqualAddresses_WhenTestingIfEqual_ThenTheResponseIsTrue() {
        // GIVEN
        let placemark = correctPlacemark()
        let address = PostalAddress(placemark: placemark)
        let address2 = PostalAddress(placemark: placemark)
        
        // WHEN
        let result = address == address2
        
        // THEN
        XCTAssertTrue(result)
    }
    
    func test_GivenToDifferentAddresses_WhenTestingIfEqual_ThenTheResponseIsFalse() {
        // GIVEN
        let placemark = correctPlacemark()
        let placemark2 = correctPlacemark2()
        let address = PostalAddress(placemark: placemark)
        let address2 = PostalAddress(placemark: placemark2)
        
        // WHEN
        let result = address == address2
        
        // THEN
        XCTAssertFalse(result)
    }
}

// MARK: Persistable

extension PostalAddressTests {
    func test_GivenTAnAddress_WhenGettingTheDictionaryRepresentation_ThenTheResultIsCorrect() {
        // GIVEN
        let placemark = correctPlacemark()
        let address = PostalAddress(placemark: placemark)!
        let expectedAddress = "Rue des invalides, Paris, France"
        let expectedLatitude: CLLocationDegrees = 10
        let expectedLongitude: CLLocationDegrees = 20
        
        // WHEN
        let dictionary = address.toDictionary()
        
        // THEN
        XCTAssertEqual(3, dictionary.count)
        XCTAssertEqual(expectedAddress, dictionary[PostalAddress.Keys.formattedAddress] as! String)
        XCTAssertEqual(expectedLatitude, dictionary[PostalAddress.Keys.latitude] as! CLLocationDegrees)
        XCTAssertEqual(expectedLongitude, dictionary[PostalAddress.Keys.longitude] as! CLLocationDegrees)
    }
    
    func test_GivenTACorrectDictionary_WhenInitializingAPostalAddress_ThenTheResultIsCorrect() {
        // GIVEN
        let dictionary: [String: Any] = [
            PostalAddress.Keys.formattedAddress: "Rue des invalides, Paris, France",
            PostalAddress.Keys.latitude: 10 as CLLocationDegrees,
            PostalAddress.Keys.longitude: 20 as CLLocationDegrees
        ]
        let placemark = correctPlacemark()
        let expectedAddress = PostalAddress(placemark: placemark)!
        
        // WHEN
        let address = PostalAddress(with: dictionary)
        
        // THEN
        XCTAssertEqual(expectedAddress, address)
    }
}

// MARK: Utils

extension PostalAddressTests {
    fileprivate func correctPlacemark() -> PlacemarkType {
        return MockPlacemark(location: CLLocation(latitude: 10, longitude: 20),
                             addressDictionary: ["FormattedAddressLines": ["Rue des invalides", "Paris, France"] ])
    }

    fileprivate func correctPlacemark2() -> PlacemarkType {
        return MockPlacemark(location: CLLocation(latitude: 20, longitude: 20),
                             addressDictionary: ["FormattedAddressLines": ["Rue des lilas", "Paris, France"] ])
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
