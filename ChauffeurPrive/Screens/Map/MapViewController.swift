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
    
    private let viewModel: MapViewModel
    private let disposeBag: DisposeBag
    
    // MARK: Initializers
    
    init() {
        self.viewModel = MapViewModel()
        self.mapView = MGLMapView(frame: .zero)
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
    
    // MARK: Binding
    
    private func setupBinding() {
        viewModel.locationAuthorized
            .filter { !$0 }
            .drive(onNext: { [weak self] _ in self?.locationNotAuthorized() })
            .addDisposableTo(disposeBag)
        
        viewModel.locationAuthorized
            .filter { $0 }
            .drive(onNext: { [weak self] _ in self?.locationAuthorized() })
            .addDisposableTo(disposeBag)
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
}

// MARK: MGLMapViewDelegate

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        guard let userLocation = userLocation else { return }
        mapView.setCenter(userLocation.coordinate, zoomLevel: 12.0, animated: true)
    }
}
