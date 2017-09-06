
//  Contact.swift
//  FieldSales
//
//  Created by Jason Wells on 7/13/16.
//  Copyright © 2016 FieldSalesOrginization. All rights reserved.
//

import Foundation
import SwiftyJSON

class Contact: CSRecord, ObjectLabelProtocol {
    
    static let objectType: String = "Contact"
    
    enum Field: String {
        case description = "Description"
        case accountId = "AccountId"
        case account = "Account__r"
    }
    fileprivate(set) lazy var accountId: String? = self.getString(Field.accountId.rawValue)
    fileprivate(set) lazy var account: Account? = self.getReference(Field.account.rawValue)
    fileprivate(set) lazy var description: String? = self.getString(Field.description.rawValue)
    fileprivate(set) lazy var name: String? = self.getString(Field.name.rawValue)
    
    convenience init() {
        self.init(objectType: Contact.objectType)
    }
    
    static func from(_ record: CSRecord?) -> Contact? {
        if let record = record {
            return Contact(json: record.json.value)
        }
        return nil
    }
    
    static func from(_ records: [CSRecord]?) -> [Contact]? {
        return records?.map { Contact(json: $0.json.value) } ?? nil
    }
}
