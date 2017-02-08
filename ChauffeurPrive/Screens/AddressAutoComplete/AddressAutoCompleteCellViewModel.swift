//
//  AddressAutoCompleteCellViewModel.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation
import Contacts

final class AddressAutoCompleteCellViewModel {
    let address: PostalAddress
    let formattedAddress: String
    
    // MARK: Initializer
    
    init(address: PostalAddress) {
        self.address = address
        self.formattedAddress = address.formattedAddress
    }
}
