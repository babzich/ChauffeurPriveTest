//
//  UserDefaultsSimpleStorageTests.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ChauffeurPrive

final class UserDefaultsSimpleStorageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // The string shouldn't be harcoded..
        UserDefaults.standard.removeObject(forKey: "address_list")
    }
    
    func test_GivenAPostalAddress_WhenIPersistIt_ThenItGoesIntoTheInMemoryCacheAndICanRetrieveIt() {
        // GIVEN
        var storage = UserDefaultsSimpleStorage<PostalAddress>()
        let address = PostalAddress(placemark: mockPlacemark())!
        
        // WHEN
        storage.add(address)
        
        // THEN
        XCTAssertEqual(storage.all().first, address)
    }
    
    func test_GivenAPostalAddress_WhenIPersistIt_ThenICanRetrieveItFromAnotherStorageInstance() {
        // GIVEN
        var storage = UserDefaultsSimpleStorage<PostalAddress>()
        let address = PostalAddress(placemark: mockPlacemark())!
        
        // WHEN
        storage.add(address)
        let storage2 = UserDefaultsSimpleStorage<PostalAddress>()
        
        // THEN
        XCTAssertEqual(storage2.all().first, address)
    }
    
    func test_GivenALotOfPostalAddress_WhenIPersistIt_ThenTheCacheDoesntGrowBiggerThatTheLimit() {
        // GIVEN
        let storageCapacity = 5
        var storage = UserDefaultsSimpleStorage<PostalAddress>(storageCapacity: storageCapacity)
        
        // WHEN
        for _ in 0..<10 {
            storage.add(PostalAddress(placemark: mockPlacemark())!)
        }
        
        // THEN
        XCTAssertEqual(storage.all().count, storageCapacity)
    }
     
}

// MARK: Utils

extension UserDefaultsSimpleStorageTests {
    fileprivate func mockPlacemark() -> PlacemarkType {
        return MockPlacemark(location: CLLocation(latitude: 10, longitude: 20),
                             addressDictionary: ["FormattedAddressLines": ["Rue des invalides", "Paris, France"] ])
    }
}
