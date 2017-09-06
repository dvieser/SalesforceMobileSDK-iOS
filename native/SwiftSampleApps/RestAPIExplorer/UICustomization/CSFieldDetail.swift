//
//  CSFieldDetail.swift
//  CSMobileBase
//
//  Created by Jason Wells on 8/8/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSFieldDetail: CustomStringConvertible {
    
    public var description: String
    
    public let label: String?
    public let type: CSFieldType?
    public let extraTypeInfo: String?
    public let pickListValues: [CSPickListValue]
    public let referenceTo: [String]
    public let relationshipName: String?
    
    internal enum Name: String {
        case label = "label"
        case type = "type"
        case extraTypeInfo = "extraTypeInfo"
        case pickListValues = "picklistValues"
        case relationshipName = "relationshipName"
        case referenceTo = "referenceTo"
    }
    
    internal init(json: JSON) {
        description = json.description
        label = json[Name.label.rawValue].string
        if let string: String = json[Name.type.rawValue].string?.uppercased() {
            type = CSFieldType(rawValue: string)
        }
        else {
            type = nil
        }
        extraTypeInfo = json[Name.extraTypeInfo.rawValue].string
        if let array: [JSON] = json[Name.pickListValues.rawValue].array {
            pickListValues = array.map { CSPickListValue(json: $0) }
        }
        else {
            pickListValues = []
        }
        if let array: [JSON] = json[Name.referenceTo.rawValue].array {
            referenceTo = array.map { $0.stringValue }
        }
        else {
            referenceTo = []
        }
        relationshipName = json[Name.relationshipName.rawValue].string
    }
    
}
