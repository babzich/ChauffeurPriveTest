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

protocol MapViewModelType {
    // Input
    var viewDidAppear: PublishSubject<Void> { get }
    
    // Output
    var locationAuthorized: Driver<Bool> { get }
}

final class MapViewModel: MapViewModelType {
    private let locationService: LocationService
    
    var viewDidAppear: PublishSubject<Void>
    var locationAuthorized: Driver<Bool>
    
    
    // MARK: Initializers
    
    init(locationService: LocationService) {
        self.locationService = locationService
        self.viewDidAppear = PublishSubject<Void>()
        
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
