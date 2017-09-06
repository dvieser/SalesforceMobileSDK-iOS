//
//  ObjectLabelProtocol.swift
//  FieldVisit
//
//  Created by David Vieser on 4/27/17.
//  Copyright © 2017 Salesforce, Inc. All rights reserved.
//

import Foundation

protocol ObjectLabelProtocol {
    static var objectType: String { get }
    static var label: String { get }
    static var labelPlural: String { get }
}

extension ObjectLabelProtocol {
    
    static var label: String {
        return (CSSettingsStore.instance.read().object(objectType)?.label) ?? ""
    }
    
    static var labelPlural: String {
        return (CSSettingsStore.instance.read().object(objectType)?.labelPlural) ?? ""
    }
}
