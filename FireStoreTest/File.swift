//
//  File.swift
//  FireStoreTest
//
//  Created by Ashish Kumar Mourya on 24/01/18.
//  Copyright © 2018 Ashish Kumar Mourya. All rights reserved.
//

import Foundation

protocol DocumentSerialize {
    
    init?(dictionay:[String:Any])
}


struct user{
    var name: String
    var address: String
    var timestamp: Date
    
    var dictionary:[String: Any] {
        return[
            "name" : name,
            "address": address,
            "date" : timestamp
        ]
    }
}


extension user:DocumentSerialize {
    init?(dictionay: [String : Any]) {
        
        guard let name = dictionay["name"] as? String,
            let address = dictionay["address"] as? String,
            let dateCurrent = dictionay["date"] as? Date else {
                return nil }
        
        self.init(name: name, address: address, timestamp: dateCurrent)
        
    }
    
    
    
    
    
    
}

