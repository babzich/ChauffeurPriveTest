//
//  MapViewModel.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 06/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

protocol MapViewModelType {
    // Input
    var viewDidAppear: PublishSubject<Void> { get }
    var didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel> { get }
    var pinLocationCoordinate: PublishSubject<CLLocationCoordinate2D> { get }
    
    // Output
    var searchPlaceholder: String { get }
    var pinLocationFormattedAddress: Driver<String> { get }
    var locationAuthorized: Driver<Bool> { get }
    var location: Driver<CLLocationCoordinate2D> { get }
    var selectedAddressCoordinate: Driver<CLLocationCoordinate2D?> { get }
    var selectedAddressFormatted: Driver<String> { get }
}

final class MapViewModel: MapViewModelType {
    private let locationService: LocationServiceType
    private let geocodingService: GeocodingServiceType
    
    let searchPlaceholder: String
    let viewDidAppear: PublishSubject<Void>
    let didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel>
    let pinLocationCoordinate: PublishSubject<CLLocationCoordinate2D>
    
    let locationAuthorized: Driver<Bool>
    let pinLocationFormattedAddress: Driver<String>
    let location: Driver<CLLocationCoordinate2D>
    let selectedAddressCoordinate: Driver<CLLocationCoordinate2D?>
    let selectedAddressFormatted: Driver<String>
    
    
    // MARK: Initializers
    
    init(locationService: LocationServiceType, geocodingService: GeocodingServiceType) {
        self.locationService = locationService
        self.geocodingService = geocodingService
        self.searchPlaceholder = "Search an address"
        self.viewDidAppear = PublishSubject<Void>()
        self.didSelectAddress = PublishSubject<AddressAutoCompleteCellViewModel>()
        self.pinLocationCoordinate = PublishSubject<CLLocationCoordinate2D>()
        
        self.selectedAddressCoordinate = didSelectAddress
            .map { $0.address.coordinate }
            .asDriver(onErrorJustReturn: nil)
        
        self.selectedAddressFormatted = didSelectAddress
            .map { $0.address.formattedAddress }
            .asDriver(onErrorJustReturn: "")
        
        let authorizationAsked = locationService.authorizationStatus.asObservable()
            .map {
                if case .notDetermined = $0 { return false }
                return true
            }
            .filter { $0 }

        let authorizationStatus = locationService.authorizationStatus.asObservable()
            .filter {
                if case .notDetermined = $0 { return false }
                return true
            }
        
        self.locationAuthorized = Observable<Bool>
            .combineLatest(authorizationAsked, viewDidAppear, authorizationStatus) { $2 == .authorizedWhenInUse }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        self.pinLocationFormattedAddress = pinLocationCoordinate
            .flatMap { [geocodingService] (coordinate: CLLocationCoordinate2D) -> Observable<String> in
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                return geocodingService.reverseGeocodeLocation(location)
                    .map { $0?.formattedAddress ?? "" }
            }
            .asDriver(onErrorJustReturn: "")
        
        self.location = locationService.location
    }
    
    convenience init() {
        self.init(locationService: LocationService.instance, geocodingService: GeocodingService())
    }
}
