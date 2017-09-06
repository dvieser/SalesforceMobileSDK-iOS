//
//  CSSettings.swift
//  CSMobileBase
//
//  Created by Jason Wells on 6/27/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SwiftyJSON

open class CSSettings: CustomStringConvertible {
    
    internal enum Name: String {
        case id = "Id"
        case objects = "ObjectInfo"
        case localizedStrings = "LocalizedStrings"
    }
    
    open var description: String {
        return json.description
    }
    
    open fileprivate(set) lazy var objectTypes: [String] = self.getObjectTypes()
    open fileprivate(set) lazy var localizedStrings: JSON = self.json[Name.localizedStrings.rawValue]
    
    open var json: JSON
    
    public required init(json: JSON) {
        self.json = json
    }
    
    open func object(_ objectType: String) -> CSObject? {
        let json: JSON = self.json[Name.objects.rawValue][objectType]
        if json.isEmpty == false {
            return CSObject(json: json)
        }
        return nil
    }
    
    fileprivate func getObjectTypes() -> [String] {
        if let dictionary: [String : AnyObject] = json[Name.objects.rawValue].dictionaryObject as [String : AnyObject]? {
            return Array(dictionary.keys)
        }
        return []
    }
    
    open static func fromStoreEntry<S: CSSettings>(_ storeEntry: AnyObject?) -> S {
        if let storeEntry: NSDictionary = storeEntry as? NSDictionary {
            let json: JSON = JSON(storeEntry)
            return S(json: json)
        }
        return S(json: JSON.null)
    }
    
}
