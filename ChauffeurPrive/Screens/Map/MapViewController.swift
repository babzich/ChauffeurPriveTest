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
    private let searchTextField: UITextField
    private let locationPin: UIImageView
    
    fileprivate let viewModel: MapViewModel
    private let disposeBag: DisposeBag
    
    // MARK: Initializers
    
    init() {
        self.viewModel = MapViewModel()
        self.mapView = MGLMapView(frame: .zero)
        self.searchTextField = UITextField(frame: .zero)
        self.locationPin = UIImageView(image: Image.locationPin)
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
        
        [mapView, searchTextField, locationPin].forEach { view.addSubview($0) }
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
        locationPin.center = view.center
    }
    
    // MARK: Setup
    
    private func setupSearchTextField() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.backgroundColor = UIColor.white
        searchTextField.leftView = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 40.0))
        searchTextField.leftViewMode = .always
        searchTextField.font = Font.System.regular.of(size: 12.0)
        
        let topConstraint = searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0)
        let leftConstraint = searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0)
        let rightConstraint = searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0)
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
        
        viewModel.location
            .asObservable()
            .take(1)
            .subscribe(onNext: { [weak self] coordinate in
                self?.setupInitalMapPosition(with: coordinate)
            })
            .disposed(by: disposeBag)

        viewModel.pinLocationFormattedAddress
            .skip(1)
            .drive(searchTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: Common
    
    private func locationNotAuthorized() {
        let noPermissionViewController = MissingPermissionViewController()
        navigationController?.present(noPermissionViewController, animated: true, completion: nil)
    }
    
    private func locationAuthorized() {
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
        mapView.setCenter(coordinate, animated: true)
    }
    
    private func setupInitalMapPosition(with coordinate: CLLocationCoordinate2D) {
        mapView.setCenter(coordinate, zoomLevel: 12.0, animated: true)
        mapView.showsUserLocation = true
    }
}

// MARK: MGLMapViewDelegate

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        viewModel.pinLocationCoordinate.onNext(mapView.centerCoordinate)
    }
}
