//
//  AddressAutoCompleteViewModel.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 06/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Contacts

protocol AddressAutoCompleteViewModelType {
    // Output
    func addresses(for string: String) -> Driver<[AddressAutoCompleteCellViewModel]>
    var didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel> { get }
}

final class AddressAutoCompleteViewModel: AddressAutoCompleteViewModelType {
    private let geocodingService: GeocodingServiceType
    var didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel>
    
    // MARK: Initializers
    
    init(geocodingService: GeocodingServiceType, didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel>) {
        self.geocodingService = geocodingService
        self.didSelectAddress = didSelectAddress
    }
    
    convenience init(didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel>) {
        self.init(geocodingService: GeocodingService(), didSelectAddress: didSelectAddress)
    }
    
    // MARK: AddressAutoCompleteViewModelType
    
    func addresses(for string: String) -> Driver<[AddressAutoCompleteCellViewModel]> {
        return geocodingService.fetchAddress(string)
            .map { addresses in
                addresses.map { AddressAutoCompleteCellViewModel(address: $0)
            }
        }
        .asDriver(onErrorJustReturn: [])
    }
}
