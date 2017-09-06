
//  Account.swift
//  FieldSales
//
//  Created by Jason Wells on 7/13/16.
//  Copyright © 2016 FieldSalesOrginization. All rights reserved.
//

import Foundation
import SwiftyJSON

class Account: CSRecord, ReferenceReadable, ObjectLabelProtocol {
    
    static let objectType: String = "Account"
    
    enum Field: String {
        case ownerId = "OwnerId"
        case description = "Description"
        case phone = "Phone"
        case accountNumber = "AccountNumber"
    }
    
    fileprivate(set) lazy var name: String? = self.getString(Field.name.rawValue)
    fileprivate(set) lazy var ownerId: String? = self.getString(Field.ownerId.rawValue)
    fileprivate(set) lazy var description: String? = self.getString(Field.description.rawValue)
    fileprivate(set) lazy var phone: String? = self.getString(Field.phone.rawValue)
    fileprivate(set) lazy var accountNumber: String? = self.getString(Field.accountNumber.rawValue)
    
    convenience init() {
        self.init(objectType: Account.objectType)
    }
    
    static func from(_ record: CSRecord?) -> Account? {
        if let record = record {
            return Account(json: record.json.value)
        }
        return nil
    }
    
    static func from(_ records: [CSRecord]?) -> [Account]? {
        return records?.map { Account(json: $0.json.value) } ?? nil
    }
    
    static func read<R: CSRecord>(_ objectName: String, id: String) -> [R]? {
        //        return AccountStore.instance.read(objectName, id: id)
        return nil
    }
    
    static func read<R: CSRecord>(_ objectName: String, id: String) -> R? {
        return AccountStore.instance.read(objectName, id: id)
    }
}
