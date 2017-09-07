//
//  CallData.swift
//  RestAPIExplorer
//
//  Created by David Vieser on 9/7/17.
//  Copyright © 2017 Salesforce. All rights reserved.
//

import Foundation

struct CallData {
    var objectType: String
    var objectId: String
    var fieldList: String
    var fields: Array<String>
    var search: String
    var query: String
    var externalId: String
    var externalFieldId: String
    var userId: String
    var page: Int8
    var version: String
    var objectIdList: Array<String>
    var entityId: String
    var shareType: String
}
