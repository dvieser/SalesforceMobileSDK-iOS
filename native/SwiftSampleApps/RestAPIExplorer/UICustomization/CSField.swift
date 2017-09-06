//
//  CSField.swift
//  CSMobileBase
//
//  Created by Jason Wells on 6/27/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSField: CustomStringConvertible {
    
    public var description: String
    
    public let name: String
    public let type: CSFieldType?
    public let isCreateable: Bool
    public let isUpdateable: Bool
    public let referenceTo: String?
    public let relationshipName: String?
    public let relationshipField: String?
    
    internal enum Name: String {
        case name = "Name"
        case type = "Type"
        case isCreateable = "Createable"
        case isUpdateable = "Updateable"
        case referenceTo = "ReferenceTo"
        case relationshipName = "RelationshipName"
        case relationshipField = "RelationshipField"
    }
    
    internal init(json: JSON) {
        description = json.description
        name = json[Name.name.rawValue].stringValue
        if let string: String = json[Name.type.rawValue].string {
            type = CSFieldType(rawValue: string)
        }
        else {
            type = nil
        }
        isCreateable = json[Name.isCreateable.rawValue].boolValue
        isUpdateable = json[Name.isUpdateable.rawValue].boolValue
        referenceTo = json[Name.referenceTo.rawValue].string
        relationshipName = json[Name.relationshipName.rawValue].string
        relationshipField = json[Name.relationshipField.rawValue].string
    }
    
    internal init(dictionary: NSDictionary) {
        self.init(json: JSON(dictionary))
    }

}
