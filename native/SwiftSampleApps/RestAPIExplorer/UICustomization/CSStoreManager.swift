//
//  CCSStoreManager.swift
//  CSMobileBase
//
//  Created by Jason Wells on 6/28/16.
//  Copyright © 2016 Salesforce Services. All rights reserved.
//

import Foundation
import SmartStore
import ReachabilitySwift

open class CSStoreManager: NSObject {
    
    public static let instance: CSStoreManager = CSStoreManager()
    
    fileprivate let notificationCenter: NotificationCenter = NotificationCenter.default
    fileprivate let settingsDidChange: Selector = #selector(CSStoreManager.settingsDidChange(_:))
    
    let reachability = Reachability()!
    
    fileprivate var stores: [String : CSRecordStore] = [:]
    
    public var storeList: [String] {
        return stores.map { $0.key }
    }
    
    open var endpoint: String = "/services/apexrest/"
    
    fileprivate override init() {
        super.init()
        SalesforceSDKManager.setInstanceClass(SalesforceSDKManagerWithSmartStore.self)
        
        notificationCenter.addObserver(self, selector: settingsDidChange, name: NSNotification.Name(rawValue: CSSettingsChangedNotification), object: nil)
        
        reachability.whenReachable = { reachability in
            SFLogger.log(SFLogLevel.debug, msg: "Connection Status Changed")
            CSStoreManager.instance.syncUp()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    open func registerStore(_ recordStore: CSRecordStore) {
        stores[recordStore.objectType] = recordStore
    }
    
    open func retrieveStore(_ objectType: String) -> CSRecordStore {
        if let recordStore: CSRecordStore = stores[objectType] {
            return recordStore
        }
        return CSRecordStore(objectType: objectType)
    }
    
    open func syncUp(onCompletion completion: ((Bool) -> Void)? = nil) {
        for recordStore: CSRecordStore in stores.values {
            recordStore.syncUp(onCompletion: completion)
        }
    }
    
    internal func settingsDidChange(_ notification: Notification) {
        if let settings: CSSettings = notification.object as? CSSettings {
            for objectType: String in settings.objectTypes {
                retrieveStore(objectType).indexStore()
            }
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
}
