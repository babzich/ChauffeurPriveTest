//
//  AddressAutoCompleteView.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AddressAutoCompleteView: UIView {
    let searchBar: UISearchBar
    let tableView: UITableView
    
    private let viewModel: AddressAutoCompleteViewModelType
    private let disposeBag: DisposeBag
    
    private enum Constants {
        static let autocompleteCellIdentifier = "AutoCompleteCell"
    }
    
    // MARK: Initializers
    
    init(searchBar: UISearchBar, viewModel: AddressAutoCompleteViewModelType) {
        self.searchBar = searchBar
        self.tableView = UITableView()
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupView() {
        addSubview(tableView)
        setupTableView()
        bind()
    }
    
    private func setupTableView() {
        tableView.register(AddressAutoCompleteTableViewCell.self, forCellReuseIdentifier: Constants.autocompleteCellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 40.0
        
        let topConstraint = tableView.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leftConstraint = tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let rightConstraint = tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    // MARK: Binding
    
    private func bind() {
        // Missing: empty state && error state
        searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { $0.characters.count > 3 }
            .bindTo(viewModel.addressInput)
            .disposed(by: disposeBag)
        
        viewModel.addresses
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: Constants.autocompleteCellIdentifier, cellType: AddressAutoCompleteTableViewCell.self)) { (row, viewModel, cell) in
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bindTo(viewModel.itemSelected)
            .disposed(by: disposeBag)
    }
}
