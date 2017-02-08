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
    private let autocompleteService: AddressAutocompleteServiceType
    var didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel>
    
    // MARK: Initializers
    
    init(autocompleteService: AddressAutocompleteServiceType, didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel>) {
        self.autocompleteService = autocompleteService
        self.didSelectAddress = didSelectAddress
    }
    
    convenience init(didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel>) {
        self.init(autocompleteService: AddressAutocompleteService(), didSelectAddress: didSelectAddress)
    }
    
    // MARK: AddressAutoCompleteViewModelType
    
    func addresses(for string: String) -> Driver<[AddressAutoCompleteCellViewModel]> {
        return autocompleteService.fetchAddress(string)
            .map { addresses in
                addresses.map { AddressAutoCompleteCellViewModel(address: $0)
            }
        }
        .asDriver(onErrorJustReturn: [])
    }
}
