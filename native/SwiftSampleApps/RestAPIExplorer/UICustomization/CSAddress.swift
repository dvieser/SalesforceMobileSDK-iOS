//
//  CSAddress.swift
//  CSMobileBase
//
//  Created by Jason Wells on 7/22/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSAddress {
    
    public var description: String
    
    public var street: String?
    public var city: String?
    public var stateCode: String?
    public var postalCode: String?
    public var countryCode: String?
    
    internal enum Name: String {
        case street = "street"
        case city = "city"
        case stateCode = "stateCode"
        case postalCode = "postalCode"
        case countryCode = "countryCode"
    }
    
    internal var dictionary: [String : AnyObject] {
        var dictionary: [String : AnyObject] = [:]
        dictionary[Name.street.rawValue] = street as AnyObject?
        dictionary[Name.city.rawValue] = city as AnyObject?
        dictionary[Name.stateCode.rawValue] = stateCode as AnyObject?
        dictionary[Name.postalCode.rawValue] = postalCode as AnyObject?
        dictionary[Name.countryCode.rawValue] = countryCode as AnyObject?
        return dictionary
    }
    
    internal init(json: JSON) {
        description = json.description
        street = json[Name.street.rawValue].string
        city = json[Name.city.rawValue].string
        stateCode = json[Name.stateCode.rawValue].string
        postalCode = json[Name.postalCode.rawValue].string
        countryCode = json[Name.countryCode.rawValue].string
    }
    
    internal init(dictionary: NSDictionary) {
        self.init(json: JSON(dictionary))
    }

}
