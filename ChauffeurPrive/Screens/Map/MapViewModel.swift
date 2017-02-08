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
    
    // Output
    var searchPlaceholder: String { get }
    var locationAuthorized: Driver<Bool> { get }
    var selectedAddressCoordinate: Driver<CLLocationCoordinate2D?> { get }
    var selectedAddressFormatted: Driver<String> { get }
}

final class MapViewModel: MapViewModelType {
    private let locationService: LocationService
    
    let searchPlaceholder: String
    let viewDidAppear: PublishSubject<Void>
    let didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel>
    let locationAuthorized: Driver<Bool>
    let selectedAddressCoordinate: Driver<CLLocationCoordinate2D?>
    let selectedAddressFormatted: Driver<String>
    
    
    // MARK: Initializers
    
    init(locationService: LocationService) {
        self.locationService = locationService
        self.searchPlaceholder = "Search an address"
        self.viewDidAppear = PublishSubject<Void>()
        self.didSelectAddress = PublishSubject<AddressAutoCompleteCellViewModel>()
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
    }
    
    convenience init() {
        self.init(locationService: LocationService.instance)
    }
}
