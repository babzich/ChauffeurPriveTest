//
//  MGLMapView+ExtensionsTests.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import XCTest
@testable import ChauffeurPrive
import Mapbox

final class MGLMapView_ExtensionsTests: XCTestCase {
    func test_GivenAMapWithoutAnnotation_WhenCallingContains_ThenItShouldReturnFalse() {
        // GIVEN
        let map = MGLMapView()
        let annotation = makeAnnotation()
        
        // WHEN
        let result = map.contains(annotation)
        
        // THEN
        XCTAssertFalse(result)
    }
    
    func test_GivenAMapWithAnnotation_WhenCallingContains_ThenItShouldReturnTrue() {
        // GIVEN
        let map = MGLMapView()
        let annotation = makeAnnotation()
        map.addAnnotation(annotation)
        
        // WHEN
        let result = map.contains(annotation)
        
        // THEN
        XCTAssertTrue(result)
    }
    
    func test_GivenAMapThatDoesntContainTheAnnotation_WhenCallingContains_ThenItShouldReturnFalse() {
        // GIVEN
        let map = MGLMapView()
        let annotation = makeAnnotation()
        let annotation2 = makeAnnotation(latitude: 14.0, longitude: 7.0)
        map.addAnnotation(annotation)
        
        // WHEN
        let result = map.contains(annotation2)
        
        // THEN
        XCTAssertFalse(result)
    }
}

// MARK: Utilis

extension MGLMapView_ExtensionsTests {
    fileprivate func makeAnnotation(latitude: CLLocationDegrees = 10.0, longitude: CLLocationDegrees = 12.0) -> MGLPointAnnotation {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return annotation
    }
}
