//
//  CSLayoutRow.swift
//  CSMobileBase
//
//  Created by Jason Wells on 8/8/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSLayoutRow: CustomStringConvertible {
    
    public var description: String
    
    public let layoutItems: [CSLayoutItem]
    
    internal enum Name: String {
        case layoutItems = "layoutItems"
    }
    
    internal init(json: JSON) {
        description = json.description
        if let array: [JSON] = json[Name.layoutItems.rawValue].array {
            layoutItems = array.map { CSLayoutItem(json: $0) }
        }
        else {
            layoutItems = []
        }
    }
    
}
