//
//  AddressAutocompleteViewController.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 06/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AddressAutoCompleteViewController: UIViewController {
    private let viewModel: AddressAutoCompleteViewModelType
    private let searchController: UISearchController
    private let autocompleteView: AddressAutoCompleteView
    
    private let disposeBag: DisposeBag
    
    // MARK: Initializers
    
    init(viewModel: AddressAutoCompleteViewModelType) {
        self.viewModel = viewModel
        self.searchController = UISearchController(searchResultsController: nil)
        self.autocompleteView = AddressAutoCompleteView(searchBar: searchController.searchBar, viewModel: viewModel)
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func loadView() {
        view = autocompleteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        navigationItem.titleView = searchController.searchBar
        bind()
    }
    
    // MARK: Binding
    
    private func bind() {
        searchController.searchBar.rx.cancelButtonClicked.subscribe(onNext: {
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
        
        viewModel.didSelectAddress.subscribe(onNext: { _ in
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }
}

