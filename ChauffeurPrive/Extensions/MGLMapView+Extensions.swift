//
//  MGLMapView+Extensions.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import Mapbox

extension MGLMapView {
    func contains(_ annotation: MGLPointAnnotation) -> Bool {
        guard let annotations = annotations else { return false }
        return annotations.contains(where: { $0.coordinate == annotation.coordinate })
    }
}
