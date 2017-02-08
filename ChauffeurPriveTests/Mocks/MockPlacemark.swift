//
//  MockPlacemark.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import CoreLocation
@testable import ChauffeurPrive

struct MockPlacemark: PlacemarkType {
    let location: CLLocation?
    let addressDictionary: [AnyHashable : Any]?
}
