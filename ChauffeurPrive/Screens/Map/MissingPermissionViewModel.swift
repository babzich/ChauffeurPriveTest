//
//  MissingPermissionViewModel.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 06/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MissingPermissionViewModelType {
    // Output
    var title: String { get }
    var description: String { get }
    var actionButtonText: String { get }
}

final class MissingPermissionViewModel: MissingPermissionViewModelType {
    let title: String
    let description: String
    let actionButtonText: String
    
    // MARK: Initializers
    
    init() {
        self.title = "Location services turned off"
        self.description = "Turn on location services in your device settings to improve your pickup experience."
        self.actionButtonText = "Turn on location services"
    }
}
