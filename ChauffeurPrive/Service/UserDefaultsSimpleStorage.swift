//
//  UserDefaultsSimpleStorage.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import Foundation

protocol SimpleStorageProtocol {
    associatedtype T: Persistable
    
    mutating func add(_ object: T)
    func all() -> [T]
}

// It's important to note that the current implementation is really naive and IS NOT thread safe
struct UserDefaultsSimpleStorage<T: Persistable>: SimpleStorageProtocol {
    private let storage = UserDefaults.standard
    private var memory = [T]()
    private let storageCapacity: Int
    
    let storageKey = "address_list"
    
    // MARK: Initializer
    
    init(storageCapacity: Int = 15) {
        let dataDictionaries = storage.object(forKey: storageKey) as? [[String: Any]] ?? []
        let data = dataDictionaries.flatMap { T(with: $0) }
        
        self.memory = data
        self.storageCapacity = storageCapacity
    }
    
    // MARK: SimpleStorageProtocol
    
    mutating func add(_ object: T) {
        if memory.count == storageCapacity {
            _ = memory.removeFirst()
        }
        
        memory.append(object)
        save()
    }
    
    func all() -> [T] {
        return memory
    }
    
    // MARK: Common
    
    private func save() {
        let data = memory.map { $0.toDictionary() }
        storage.set(data, forKey: storageKey)
    }
}
