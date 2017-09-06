//
//  AccountStore.swift
//  CPG-FieldSales
//
//  Created by Guy Umbright on 8/22/16.
//  Copyright © 2016 FieldSalesOrginization. All rights reserved.
//

import Foundation
import SwiftyJSON
import SmartStore

class ContactStore: CSRecordStore {
    
    static let instance: ContactStore = ContactStore(objectType: Contact.objectType)
    
//    override var readFields: CSFieldSet {
//        return super.readFields
//            .withField(Account.Field.name.rawValue)
//            .withField(Account.Field.ownerId.rawValue)
////            .withField(Account.Field.accountPgId.rawValue)
//            .withField(Account.Field.description.rawValue)
//            .withField(Account.Field.phone.rawValue)
//            .withField(Account.Field.accountNumber.rawValue)
//
////            .withRelationField(Account.Field.storeManager.rawValue, name: Contact.Field.name.rawValue)
//    }
    
    override var indexes: [[String: String]] {
        return super.indexes + [
            ["path" : Contact.Field.accountId.rawValue, "type" : kSoupIndexTypeString],
        ]
    }

        
    open func readContacts(forAccount account: Account? = nil) -> [Contact]? {
        let contact = super.read { query in
            if let accountId = account?.id {
                return query.whereEqual(Contact.Field.accountId.rawValue, value: accountId)
            }
            return query
        }
        return Contact.from(contact)
    }
}
