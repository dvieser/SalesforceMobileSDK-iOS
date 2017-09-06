//
//  CSPersonName.swift
//  CSMobileBase
//
//  Created by Jason Wells on 8/8/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSPersonName {
    
    public var salutation: String?
    public var firstName: String?
    public var lastName: String?
    
    internal enum Name: String {
        case salutation = "Salutation"
        case firstName = "FirstName"
        case lastName = "LastName"
    }
    
    internal init(record: CSRecord?) {
        salutation = record?.getString(Name.salutation.rawValue)
        firstName = record?.getString(Name.firstName.rawValue)
        lastName = record?.getString(Name.lastName.rawValue)
    }
    
}
