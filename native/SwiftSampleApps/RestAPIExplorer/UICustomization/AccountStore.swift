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

class AccountStore: CSRecordStore {
    
    static let instance: AccountStore = AccountStore(objectType: Account.objectType)
    
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
    
//    override var indexes: [[String: String]] {
//        return super.indexes + [
//            ["path" : Account.Field.ownerId.rawValue, "type" : kSoupIndexTypeString],
//            ["path" : Account.Field.accountPgId.rawValue, "type" : kSoupIndexTypeString]
//        ]
//    }

    open func read<R: CSRecord>(_ objectName: String, id: String) -> R? {
        let account = super.read { query in
            return query.whereEqual(Account.Field.id.rawValue, value: id)
        }.first
        let a = Account.from(account)
        return a as! R?
    }
}
