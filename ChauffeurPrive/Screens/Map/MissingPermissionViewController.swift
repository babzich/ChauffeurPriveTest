//
//  MissingPermissionViewController.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 06/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MissingPermissionViewController: UIViewController {
    private let viewModel: MissingPermissionViewModel
    private let noLocationView: MissingPermissionView
    
    // MARK: Initializers
    init() {
        self.viewModel = MissingPermissionViewModel()
        self.noLocationView = MissingPermissionView(viewModel: viewModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func loadView() {
        view = noLocationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.black
    }
}
