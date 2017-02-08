//
//  AddressAutocompleteService.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 07/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import CoreLocation
import Contacts
import RxSwift
import RxCocoa

protocol AddressAutocompleteServiceType {
    func fetchAddress(_ address: String) -> Observable<[PostalAddress]>
}

final class AddressAutocompleteService: AddressAutocompleteServiceType {
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
}
