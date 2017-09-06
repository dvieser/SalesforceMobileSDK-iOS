//
//  CSObject.swift
//  CSMobileBase
//
//  Created by Jason Wells on 6/27/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSObject: CustomStringConvertible {
    
    public var description: String
    
    public let label: String?
    public let labelPlural: String?
    public let isAccessible: Bool
    public let isCreateable: Bool
    public let isUpdateable: Bool
    public let isDeletable: Bool
    public let isSearchable: Bool
    public let nameField: String?
    public let searchFields: [String]
    public let fields: [CSField]
    public let recordTypes: [CSRecordType]
    
    internal enum Name: String {
        case label = "Label"
        case labelPlural = "LabelPlural"
        case isAccessible = "Accessible"
        case isCreateable = "Createable"
        case isUpdateable = "Updateable"
        case isDeleteable = "Deletable"
        case isSearchable = "Searchable"
        case nameField = "Name"
        case fields = "FieldInfo"
        case searchFields = "SearchableFields"
        case recordTypes = "RecordTypeInfo"
    }
    
    internal init(json: JSON) {
        description = json.description
        label = json[Name.label.rawValue].string
        labelPlural = json[Name.labelPlural.rawValue].string
        isAccessible = json[Name.isAccessible.rawValue].boolValue
        isCreateable = json[Name.isCreateable.rawValue].boolValue
        isUpdateable = json[Name.isUpdateable.rawValue].boolValue
        isDeletable = json[Name.isDeleteable.rawValue].boolValue
        isSearchable = json[Name.isSearchable.rawValue].boolValue
        nameField = json[Name.nameField.rawValue].string
        if let array: [JSON] = json[Name.fields.rawValue].array {
            fields = array.map { CSField(json: $0) }
        }
        else {
            fields = []
        }
        if let array: [JSON] = json[Name.searchFields.rawValue].array {
            searchFields = array.map { $0.stringValue }
        }
        else {
            searchFields = []
        }
        if let dictionary: [String : JSON] = json[Name.recordTypes.rawValue].dictionary {
            recordTypes = Array(dictionary.values).map { CSRecordType(json: $0) }
        }
        else {
            recordTypes = []
        }
    }
    
    internal init(dictionary: NSDictionary) {
        self.init(json: JSON(dictionary))
    }
    
}
