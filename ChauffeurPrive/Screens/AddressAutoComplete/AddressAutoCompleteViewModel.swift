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

protocol AddressAutoCompleteViewModelType {
    // Input
    var addressInput: PublishSubject<String> { get }
    // Output
    var addresses: Variable<[AddressAutoCompleteCellViewModel]> { get }
    var itemSelected: PublishSubject<IndexPath> { get }
//    var didSelectAddress: PublishSubject<AddressAutoCompleteCellViewModel> { get }
}

final class AddressAutoCompleteViewModel: AddressAutoCompleteViewModelType {
    private let geocodingService: GeocodingServiceType
    
    let addressInput: PublishSubject<String>
    let addresses: Variable<[AddressAutoCompleteCellViewModel]>
    let itemSelected: PublishSubject<IndexPath>
    
    private let disposeBag: DisposeBag
    
    weak var navigationCoordinator: AddressAutoCompleteCoordinator? {
        didSet {
            guard let navigationCoordinator = navigationCoordinator else { return }
            itemSelected
                .map { self.addresses.value[$0.row] }
                .map { $0.address }
                .bindTo(navigationCoordinator.didTapAddress)
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: Initializers
    
    init(geocodingService: GeocodingServiceType) {
        self.geocodingService = geocodingService
        self.addressInput = PublishSubject<String>()
        self.addresses = Variable<[AddressAutoCompleteCellViewModel]>([])
        self.itemSelected = PublishSubject<IndexPath>()
        self.disposeBag = DisposeBag()
        
        bind()
    }
    
    convenience init() {
        self.init(geocodingService: GeocodingService())
    }
    
    // MARK: Binding
    
    private func bind() {
        addressInput
            .flatMap { string in
                return self.geocodingService.fetchAddress(string)
                    .catchErrorJustReturn([])
                    .map { $0.map { AddressAutoCompleteCellViewModel(address: $0) }
                }
            }
            .bindTo(addresses)
            .disposed(by: disposeBag)
    }
}
