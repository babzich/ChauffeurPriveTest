//
//  AddressAutocompleteCoordinator.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit
import RxSwift

final class AddressAutoCompleteCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    
    let didTapAddress: PublishSubject<PostalAddress>
    private let disposeBag: DisposeBag
    
    // MARK: Initializer
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.didTapAddress = PublishSubject<PostalAddress>()
        self.disposeBag = DisposeBag()
    }
    
    // MARK: Coordinator
    
    func start() {
        let viewModel = AddressAutoCompleteViewModel()
        viewModel.navigationCoordinator = self
        let viewController = AddressAutoCompleteViewController(viewModel: viewModel)
        let navigationtionController = UINavigationController(rootViewController: viewController)
        navigationController?.present(navigationtionController, animated: true, completion: nil)
    }
    
    func stop() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
