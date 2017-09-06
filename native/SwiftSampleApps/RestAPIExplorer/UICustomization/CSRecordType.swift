//
//  CSRecordType.swift
//  CSMobileBase
//
//  Created by Jason Wells on 6/27/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSRecordType: CustomStringConvertible {
    
    public var description: String
    
    public let id: String
    public let label: String?
    public let isAvailable: Bool
    
    internal enum Name: String {
        case id = "Id"
        case label = "Label"
        case isAvailable = "IsAvailable"
    }
    
    internal init(json: JSON) {
        description = json.description
        id = json[Name.id.rawValue].stringValue
        label = json[Name.label.rawValue].string
        isAvailable = json[Name.isAvailable.rawValue].boolValue
    }
    
    internal init(dictionary: NSDictionary) {
        self.init(json: JSON(dictionary))
    }
    
}
