//
//  CSLayoutItem.swift
//  CSMobileBase
//
//  Created by Jason Wells on 8/8/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSLayoutItem: CustomStringConvertible {
    
    public var description: String
    
    public let label: String?
    public let required: Bool
    public let editableForUpdate: Bool
    public let editableForNew: Bool
    public let layoutComponents: [CSLayoutComponent]
    
    internal enum Name: String {
        case label = "label"
        case required = "required"
        case editableForUpdate = "editableForUpdate"
        case editableForNew = "editableForNew"
        case layoutComponents = "layoutComponents"
    }
    
    internal init(json: JSON) {
        description = json.description
        label = json[Name.label.rawValue].string
        required = json[Name.required.rawValue].boolValue
        editableForUpdate = json[Name.editableForUpdate.rawValue].boolValue
        editableForNew = json[Name.editableForNew.rawValue].boolValue
        if let array: [JSON] = json[Name.layoutComponents.rawValue].array {
            layoutComponents = array.map { CSLayoutComponent(json: $0) }
        }
        else {
            layoutComponents = []
        }
    }
    
}
