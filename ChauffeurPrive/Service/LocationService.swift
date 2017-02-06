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

final class LocationService {
    static let instance = LocationService()
    let authorizationStatus: Driver<CLAuthorizationStatus>
    
    private let locationManager = CLLocationManager()
    
    // MARK: Initializer
    
    init() {
        authorizationStatus = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx.didChangeAuthorizationStatus
                .startWith(status)
            }
            .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
        
        locationManager.requestWhenInUseAuthorization()
    }
}
