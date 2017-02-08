//
//  MapCoordinator.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit
import RxSwift

final class MapCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    
    let didTapAddress: PublishSubject<Void>
    let didSelectAddress: PublishSubject<PostalAddress>
    private let disposeBag: DisposeBag
    
    // MARK: Initializer
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.didTapAddress = PublishSubject<Void>()
        self.didSelectAddress = PublishSubject<PostalAddress>()
        self.disposeBag = DisposeBag()
        bind()
    }
    
    // MARK: Coordinator
    
    func start() {
        let mapViewModel = MapViewModel()
        mapViewModel.navigationCoordinator = self
        didSelectAddress
            .bindTo(mapViewModel.didSelectAddress)
            .disposed(by: disposeBag)
        let mapController = MapViewController(viewModel: mapViewModel)
        navigationController?.setViewControllers([mapController], animated: false)
    }
    
    func stop() {
        
    }
    
    // MARK: Binding
    
    private func bind() {
        didTapAddress
            .subscribe(onNext: { [weak self] _ in self?.presentAutocompleteView() })
            .disposed(by: disposeBag)
    }
    
    // MARK: Common
    
    private func presentAutocompleteView() {
        let coordinator = AddressAutoCompleteCoordinator(navigationController: navigationController)
        
        coordinator
            .didTapAddress
            .bindTo(didSelectAddress)
            .disposed(by: disposeBag)
        
        coordinator
            .didTapAddress
            .subscribe(onNext: { _ in coordinator.stop() })
            .disposed(by: disposeBag)
        
        coordinator.start()
        
        childCoordinators.append(coordinator)
    }
}
