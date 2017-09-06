//
//  CSFieldLayout.swift
//  CSMobileBase
//
//  Created by Jason Wells on 6/28/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSFieldLayout: CustomStringConvertible {
    
    public var description: String
    
    public let name: String
    public let label: String?
    public let type: CSFieldType?
    public let extraTypeInfo: CSExtraTypeInfo?
    public let defaultValue: String?
    public let isRequired: Bool
    public let isCreateable: Bool
    public let isUpdateable: Bool
    public let length: Int?
    public let scale: Int?
    public let options: [CSPickListValue]?
    public let referenceTo: String?
    public let relationshipName: String?
    public let relationshipField: String?
    public let stateOptions: [CSPickListValue]?
    public let countryOptions: [CSPickListValue]?
    public let streetField: String?
    public let cityField: String?
    public let stateCodeField: String?
    public let postalCodeField: String?
    public let countryCodeField: String?
    
    internal enum Name: String {
        case name = "Name"
        case label = "Label"
        case type = "Type"
        case extraTypeInfo = "ExtraTypeInfo"
        case defaultValue = "DefaultValue"
        case isRequired = "Required"
        case isCreateable = "Createable"
        case isUpdateable = "Updateable"
        case length = "Length"
        case scale = "Scale"
        case options = "PicklistValues"
        case referenceTo = "ReferenceTo"
        case relationshipName = "RelationshipName"
        case relationshipField = "RelationshipField"
        case stateOptions = "StatePicklistMap"
        case countryOptions = "CountryPicklistMap"
        case streetField = "Street"
        case cityField = "City"
        case stateCodeField = "State"
        case postalCodeField = "PostalCode"
        case countryCodeField = "Country"
    }
    
    internal init(json: JSON) {
        description = json.description
        name = json[Name.name.rawValue].stringValue
        label = json[Name.label.rawValue].string
        if let string: String = json[Name.type.rawValue].string {
            type = CSFieldType(rawValue: string)
        }
        else {
            type = nil
        }
        if let string: String = json[Name.extraTypeInfo.rawValue].string {
            extraTypeInfo = CSExtraTypeInfo(rawValue: string)
        }
        else {
            extraTypeInfo = nil
        }
        defaultValue = json[Name.defaultValue.rawValue].string
        isRequired = json[Name.isRequired.rawValue].boolValue
        isCreateable = json[Name.isCreateable.rawValue].boolValue
        isUpdateable = json[Name.isUpdateable.rawValue].boolValue
        if let length: String = json[Name.length.rawValue].string {
            self.length = Int(length)
        }
        else {
            self.length = nil
        }
        if let scale: String = json[Name.scale.rawValue].string {
            self.scale = Int(scale)
        }
        else {
            self.scale = nil
        }
        if let array: [JSON] = json[Name.options.rawValue].array {
            options = array.map { CSPickListValue(json: $0) }
        }
        else {
            options = nil
        }
        referenceTo = json[Name.referenceTo.rawValue].string
        relationshipName = json[Name.relationshipName.rawValue].string
        relationshipField = json[Name.relationshipField.rawValue].string
        if let array: [JSON] = json[Name.stateOptions.rawValue].array {
            stateOptions = array.map { CSPickListValue(json: $0) }
        }
        else {
            stateOptions = nil
        }
        if let array: [JSON] = json[Name.countryOptions.rawValue].array {
            countryOptions = array.map { CSPickListValue(json: $0) }
        }
        else {
            countryOptions = nil
        }
        streetField = json[Name.streetField.rawValue].string
        cityField = json[Name.cityField.rawValue].string
        stateCodeField = json[Name.stateCodeField.rawValue].string
        postalCodeField = json[Name.postalCodeField.rawValue].string
        countryCodeField  = json[Name.countryCodeField.rawValue].string
    }
    
    internal init(dictionary: NSDictionary) {
        self.init(json: JSON(dictionary))
    }
    
}
