//
//  CSPickListValue.swift
//  CSMobileBase
//
//  Created by Jason Wells on 6/29/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSPickListValue: CustomStringConvertible {
    
    public var description: String
    
    public let value: String?
    public let label: String?
    public let isActive: Bool
    public let defaultValue: Bool
    public let validFor: String?

    internal enum Name: String {
        case value = "Value"
        case label = "Label"
        case isActive = "Active"
        case defaultValue = "DefaultValue"
        case validFor = "ValidFor"
    }
    
    internal init(json: JSON) {
        description = json.description
        value = json[Name.value.rawValue].string
        label = json[Name.label.rawValue].string
        isActive = json[Name.isActive.rawValue].boolValue
        defaultValue = json[Name.defaultValue.rawValue].boolValue
        validFor = json[Name.validFor.rawValue].string
    }
    
    internal init(dictionary: NSDictionary) {
        self.init(json: JSON(dictionary))
    }

}
