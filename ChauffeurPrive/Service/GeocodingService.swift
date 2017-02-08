//
//  GeocodingService.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 07/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

protocol GeocodingServiceType {
    func fetchAddress(_ address: String) -> Observable<[PostalAddress]>
    func reverseGeocodeLocation(_ location: CLLocation) -> Observable<PostalAddress?>
}

final class GeocodingService: GeocodingServiceType {
    private let geocoder: CLGeocoder
    private let locationService: LocationServiceType
    
    // MARK: Initializers
    
    init(geocoder: CLGeocoder, locationService: LocationServiceType) {
        self.geocoder = geocoder
        self.locationService = locationService
    }
    
    convenience init() {
        self.init(geocoder: CLGeocoder(), locationService: LocationService.instance)
    }
    
    // MARK: GeocodingServiceType
    
    func fetchAddress(_ address: String) -> Observable<[PostalAddress]> {
        return locationService.currentRegion
            .asObservable()
            .take(1)
            .flatMap { (region: CLRegion) -> Observable<[PostalAddress]> in
                return self.geocoder.rx.geocodeAddressString(address, in: region).map { placemarks in
                    placemarks.flatMap { PostalAddress(placemark: $0) }
                }
            }
    }
    
    func reverseGeocodeLocation(_ location: CLLocation) -> Observable<PostalAddress?> {
        return self.geocoder.rx.reverseGeocodeLocation(location).map { (placemark: CLPlacemark?) -> PostalAddress? in
            guard let placemark = placemark else { return nil }
             return PostalAddress(placemark: placemark)
        }
    }
}
