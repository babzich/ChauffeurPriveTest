//
//  LocationService.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 04/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

protocol LocationServiceType {
    var authorizationStatus: Driver<CLAuthorizationStatus> { get }
    var location: Driver<CLLocationCoordinate2D> { get }
    var currentRegion: Variable<CLRegion> { get }
}

final class LocationService: LocationServiceType {
    static let instance = LocationService()
    let authorizationStatus: Driver<CLAuthorizationStatus>
    let location: Driver<CLLocationCoordinate2D>
    let currentRegion: Variable<CLRegion>
    
    private let locationManager: CLLocationManager
    
    enum Constants {
        static let radius: CLLocationDistance = 100000 // 100km
        static let parisCoordinate = CLLocationCoordinate2D(latitude: 48.853, longitude: 2.35)
        static let parisRegion: CLRegion = CLCircularRegion(center: Constants.parisCoordinate, radius: Constants.radius, identifier: "paris_region")
    }
    
    private let disposeBag: DisposeBag
    
    // MARK: Initializer
    
    init() {
        self.locationManager = CLLocationManager()
        self.disposeBag = DisposeBag()
        
        self.authorizationStatus = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx.didChangeAuthorizationStatus
                .startWith(status)
            }
            .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
        
        self.location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap { return $0.last.map(Driver.just) ?? Driver.empty() }
            .map { $0.coordinate }
        
        
        self.currentRegion = Variable(Constants.parisRegion)
        self.location
            .map { CLCircularRegion(center: $0, radius: Constants.radius, identifier: "user_region") }
            .asObservable()
            .bindTo(currentRegion)
            .disposed(by: disposeBag)
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
