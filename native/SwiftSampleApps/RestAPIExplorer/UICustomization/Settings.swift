//
//  Settings.swift
//  FieldService
//
//  Created by Jason Wells on 9/23/15.
//  Copyright © 2015 Salesforce Services. All rights reserved.
//

import Foundation
import SwiftyJSON
import SalesforceSDKCore

protocol Customizeable {
    func applySettings(_ settings: Settings)
}

class Settings : CSSettings {
    
    static let defaultSettings: Settings = Settings(json: JSON.null)
    
    enum Attribute: String {
        case id = "Id"
        case theme = "ThemeInfo"
        case general = "GeneralInfo"
        case packageVersion = "PackageVersionNumber"
        case maxLocationPingInMinutes = "TechnicianLocationUpdateInterval"
        case logoImageId = "LogoImageId"
        case backgroundImageId = "BackgroundImageId"
        case defaultProductImageId = "DefaultProductImageId"
        case syncOption = "csfs_Data_Sync_Option__c"
        case defaultFollowupDays = "csfs_GENERAL_Default_Followup_Days__c"
        case waveURL = "csfs_GENERAL_Wave_URL__c"
        case appExhangeURL = "csfs_GENERAL_App_Exchange__c"
        case showMapTab = "fv_GENERAL_Show_Map_Tab__c"
        case syncAttachmentBody = "fv_GENERAL_Sync_Attachment_Body__c"
    }
    
    enum syncOptions: String {
        case myRecords = "MyRecords"
        case allRecords = "AllRecords"
    }
    fileprivate(set) lazy var theme: Theme = Theme(json: self.json[Attribute.theme.rawValue])
    fileprivate(set) lazy var general: JSON = self.json[Attribute.general.rawValue]
    fileprivate(set) lazy var packageVersion: String? = self.json[Attribute.packageVersion.rawValue].string
    fileprivate(set) lazy var maxLocationPingInMinutes: Double? = self.json[Attribute.maxLocationPingInMinutes.rawValue].double
    fileprivate(set) lazy var logoImageId: String? = self.general[Attribute.logoImageId.rawValue].string
    fileprivate(set) lazy var logoImageURLString: String? = SalesforceHelper.getInstanceURL().absoluteString + Constants.contentURL + (self.logoImageId ?? "")
    fileprivate(set) lazy var backgroundImageId: String? = self.general[Attribute.backgroundImageId.rawValue].string
    fileprivate(set) lazy var backgroundImageURLString: String? = SalesforceHelper.getInstanceURL().absoluteString + Constants.contentURL + (self.backgroundImageId ?? "")
    fileprivate(set) lazy var defaultProductImageId: String? = self.general[Attribute.defaultProductImageId.rawValue].string
    fileprivate(set) lazy var defaultProductImageURLString: String? = SalesforceHelper.getInstanceURL().absoluteString + Constants.contentURL + (self.defaultProductImageId ?? "")
    fileprivate(set) lazy var defaultFollowupDays: Int? = self.general[Attribute.defaultFollowupDays.rawValue].intValue
    fileprivate(set) lazy var isOnlyMyRecords: Bool = (self.general[Attribute.syncOption.rawValue].string == syncOptions.myRecords.rawValue)
    fileprivate(set) lazy var waveURL: String? = self.general[Attribute.waveURL.rawValue].string
    fileprivate(set) lazy var appExchangeURL: String? = self.general[Attribute.appExhangeURL.rawValue].string
    
    fileprivate(set) lazy var showMapTab: Bool = (self.general[Attribute.showMapTab.rawValue].boolValue)
    fileprivate(set) lazy var syncAttachmentBody: Bool = (self.general[Attribute.syncAttachmentBody.rawValue].boolValue)
    
    func printToConsole() {
        SFLogger.log(SFLogLevel.debug, msg: json.debugDescription)
    }
}
