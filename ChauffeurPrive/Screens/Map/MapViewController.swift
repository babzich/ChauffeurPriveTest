//
//  MapViewController.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 04/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Mapbox

final class MapViewController: UIViewController {
    private let mapView: MGLMapView
    private lazy var addressAnnotation = MGLPointAnnotation()
    private let searchTextField: UITextField
    
    private let viewModel: MapViewModel
    private let disposeBag: DisposeBag
    
    // MARK: Initializers
    
    init() {
        self.viewModel = MapViewModel()
        self.mapView = MGLMapView(frame: .zero)
        self.searchTextField = UITextField(frame: .zero)
        self.disposeBag = DisposeBag()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        view.addSubview(mapView)
        view.addSubview(searchTextField)
        setupSearchTextField()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear.onNext()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    // MARK: Setup
    
    private func setupSearchTextField() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.backgroundColor = UIColor.white
        searchTextField.leftView = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 40.0))
        searchTextField.leftViewMode = .always
        
        let topConstraint = searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0)
        let leftConstraint = searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0)
        let rightConstraint = searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0)
        let heightConstraint = searchTextField.heightAnchor.constraint(equalToConstant: 40.0)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, heightConstraint])
    }
    
    // MARK: Binding
    
    private func setupBinding() {
        searchTextField.placeholder = viewModel.searchPlaceholder
        viewModel.locationAuthorized
            .filter { !$0 }
            .drive(onNext: { [weak self] _ in self?.locationNotAuthorized() })
            .disposed(by: disposeBag)
        
        viewModel.locationAuthorized
            .filter { $0 }
            .drive(onNext: { [weak self] _ in self?.locationAuthorized() })
            .disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in self?.displayAddressAutocomplete() } )
            .disposed(by: disposeBag)
        
        viewModel.selectedAddressCoordinate
            .drive(onNext: { [weak self] coordinate in
                guard let coordinate = coordinate else { return }
                self?.updateAddressPin(with: coordinate)
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedAddressFormatted
            .drive(searchTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: Common
    
    private func locationNotAuthorized() {
        let noPermissionViewController = MissingPermissionViewController()
        navigationController?.present(noPermissionViewController, animated: true, completion: nil)
    }
    
    private func locationAuthorized() {
        mapView.showsUserLocation = true
        if let presentedViewController = navigationController?.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: nil)
        }
    }
    
    private func displayAddressAutocomplete() {
        let vm = AddressAutoCompleteViewModel(didSelectAddress: viewModel.didSelectAddress)
        let autocompleteViewController = AddressAutoCompleteViewController(viewModel: vm)
        let navigationController = UINavigationController(rootViewController: autocompleteViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func updateAddressPin(with coordinate: CLLocationCoordinate2D) {
        addressAnnotation.coordinate = coordinate
        
        if !mapView.contains(addressAnnotation) {
            mapView.addAnnotation(addressAnnotation)
        }
        
        mapView.setCenter(coordinate, animated: true)
    }
}

// MARK: MGLMapViewDelegate

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        guard let userLocation = userLocation else { return }
        mapView.setCenter(userLocation.coordinate, zoomLevel: 12.0, animated: true)
    }
}
