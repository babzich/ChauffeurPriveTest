//
//  CLGeocoder+Rx.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 07/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import CoreLocation
import RxSwift

extension Reactive where Base: CLGeocoder {
    func geocodeAddressString(_ address: String, in region: CLRegion) -> Observable<[CLPlacemark]> {
        return Observable.create { observer in
            
            self.base.geocodeAddressString(address, in: region, completionHandler: { (placemarks, error) in
                if let placemarks = placemarks {
                    observer.onNext(placemarks)
                    observer.onCompleted()
                }
                else if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onError(RxError.unknown)
                }
            })
            
            return Disposables.create {
                self.base.cancelGeocode()
            }
        }
    }
    
    func reverseGeocodeLocation(_ location: CLLocation) -> Observable<CLPlacemark?> {
        return Observable.create { observer in
            
            self.base.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onNext(placemarks?.first)
                    observer.onCompleted()
                }
            })
            
            return Disposables.create {
                self.base.cancelGeocode()
            }
        }
    }
}
