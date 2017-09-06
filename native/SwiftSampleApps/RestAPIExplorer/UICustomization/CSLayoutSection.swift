//
//  CSLayoutSection.swift
//  CSMobileBase
//
//  Created by Jason Wells on 8/8/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CSLayoutSection: CustomStringConvertible {
    
    public var description: String
    
    public let heading: String?
    public let layoutRows: [CSLayoutRow]
 
    internal enum Name: String {
        case heading = "heading"
        case layoutRows = "layoutRows"
    }
    
    internal init(json: JSON) {
        description = json.description
        heading = json[Name.heading.rawValue].string
        if let array: [JSON] = json[Name.layoutRows.rawValue].array {
            layoutRows = array.map { CSLayoutRow(json: $0) }
        }
        else {
            layoutRows = []
        }
    }
    
}
