//
//  Constants.swift
//  FieldSales
//
//  Created by David Vieser on 6/29/16.
//  Copyright © 2016 FieldSalesOrginization. All rights reserved.
//

import Foundation

enum Constants {
    // Globals
    static let ReleaseVersionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let BuildVersionNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    // Notifications
    static let DisplayMessageNotification = "DisplayMessageNotification"
    static let DisplayDetailMessageNotification = "DisplayDetailMessageNotification"
    static let PinChangedNotification = "PinChangedNotification"
    static let SettingsChangedNotification = CSSettingsChangedNotification
    static let HomeStatTilesChangedNotification = "HomeStatTilesChangedNotification"
    static let VisitStatTilesChangedNotification = "VisitStatTilesChangedNotification"
    static let OpportunitiesChangedNotification = "OpportunitiesChangedNotification"
    static let ProductsChangedNotification = "ProductsChangedNotification"
    static let StoreProductsChangedNotification = "StoreProductsChangedNotification"
    static let PromotionsChangedNotification = "PromotionsChangedNotification"
    static let QuarterlyStoreSalesChangedNotification = "QuarterlyStoreSalesChangedNotification"
    static let StoreNotificationsChangedNotification = "StoreNotificationsChangedNotification"
    static let CurrentPromotionsChangedNotification = "CurrentPromotionsChangedNotification"
    static let VisitSelectedNotification = "VisitSelectedNotification"
    static let VisitObjectivesChangedNotification = "VisitObjectivesChangedNotification"
    static let VisitChangedNotification = "VisitChangedNotification"
    static let VisitsChangedNotification = "VisitsChangedNotification"
    static let VisitsInProgressChangedNotification = "VisitsInProgressChangedNotification"
    static let VisitStageSelectedNotification = "VisitStageSelectionNotification"
    static let VisitStageWillShowNotification = "VisitStageWillShowNotification"
    static let VisitsUpcomingChangedNotification = "VisitsUpcomingChangedNotification"
    static let VisitsAccountChangedNotification = "VisitsAccountChangedNotification"
    static let TasksChangedNotification = "TasksChangedNotification"
    static let TasksDueSoonChangedNotification = "TasksDueSoonChangedNotification"
    static let ContactsChangedNotification = "ContactsChangedNotification"
    static let EventsChangedNotification = "EventsChangedNotification"
    static let AccountsChangedNotification = "AccountsChangedNotification"
    static let ProductOnHandChangedNotification = "ProductOnHandChangedNotification"
    static let EndVisitNotification = "EndVisitNotification"
    static let ProductPromotionsChangedNotification = "ProductPromotionsChangedNotification"
    static let StorePromotionsChangedNotification = "ProductPromotionsChangedNotification"
    static let OrdersChangedNotification = "OrdersChangedNotification"
    static let ShowPromoChatterFeedNotification = "ShowPromoChatterFeedNotification"
    static let TakePromotionPhotoNotification = "TakePromotionPhotoNotification"
    static let PriorVisitsChangedNotification = "PriorVisitsChangedNotification"
    static let FutureStoreVisitsChangedNotification = "FutureStoreVisitsChangedNotification"
    static let VisitAuditsChangedNotification = "VisitAuditsChangedNotification"
    static let StoreProductVisitAuditsChangedNotification = "StoreProductVisitAuditsChangedNotification"
    static let StoreCheckSectionsChangedNotification = "StoreCheckSectionsChangedNotification"
    
    // Keys
    static let EndVisitSendSurveyKey = "EndVisitNotification"
    

    // Info.plist
    static let launchStoryboardName: String = Bundle.main.object(forInfoDictionaryKey: "UILaunchStoryboardName") as! String
    static let mainStoryboardName: String = Bundle.main.object(forInfoDictionaryKey: "UIMainStoryboardFile") as! String
    static let bundleName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    static let bundleVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let packageVersion: String = Bundle.main.object(forInfoDictionaryKey: "SFDCPackageVersion") as! String
    static let connectedAppId: String = Bundle.main.object(forInfoDictionaryKey: "SFDCConnectedAppId") as! String
    static let cpgSalesSurveyURL: String = Bundle.main.object(forInfoDictionaryKey: "CPGSalesSurveyURL") as! String
    static let cpgSalesChatterURL: String = Bundle.main.object(forInfoDictionaryKey: "CPGSalesChatterURL") as! String

    // Salesforce API
    static let connectedAppCallbackUri: String = Bundle.main.object(forInfoDictionaryKey: "SFDCConnectedAppCallbackUri") as! String
    static let endpoint: String = Bundle.main.object(forInfoDictionaryKey: "SFDCEndpoint") as! String
    static let apiVersion: String = Bundle.main.object(forInfoDictionaryKey: "SFDCApiVersion") as! String
    static let classPrefix: String = Bundle.main.object(forInfoDictionaryKey: "SFDCClassPrefix") as! String
    static let contentURL: String = Bundle.main.object(forInfoDictionaryKey: "SFDCContentURL") as! String
}
