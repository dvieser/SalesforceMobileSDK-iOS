//
//  SalesforceHelper.swift
//  FieldSales
//
//  Created by David Vieser on 6/30/16.
//  Copyright © 2016 FieldSalesOrginization. All rights reserved.
//

import Foundation
import SmartStore
import SwiftyJSON
import SmartSync

class SalesforceHelper {

    static let timeDidExpireSelector: Selector = #selector(SalesforceHelper.timeDidExpire(_:))
    static let soupsArray: [CSRecordStore] = [
                                AccountStore.instance,
                                ContactStore.instance,
                            ]
    

    static func startup(_ appDelegate: AppDelegate) { // , completion: (() -> Void)? ) {
        var infoLogLevel: String? = Bundle.main.infoDictionary!["SF_LOG_LEVEL"] as? String
        if infoLogLevel == nil || (infoLogLevel?.isEmpty)! {
            infoLogLevel = "Debug"
        }
        SFLogger.shared().logLevel = SFLogger.logLevel(for: infoLogLevel!)
        
        
        SalesforceSDKManager.setInstanceClass(SalesforceSDKManagerWithSmartStore.self)
        SalesforceSDKManager.shared().connectedAppId = Constants.connectedAppId
        SalesforceSDKManager.shared().connectedAppCallbackUri = Constants.connectedAppCallbackUri
        SalesforceSDKManager.shared().authScopes = ["web", "api"]
        SalesforceSDKManager.shared().useSnapshotView = true
        
        SalesforceSDKManager.shared().postLaunchAction = {
            (launchActionList: SFSDKLaunchAction) in
            let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
            SFLogger.log(.info, msg:"Post-launch: launch actions taken: \(launchActionString)");

            registerStores()

//            CSSettingsStore.instance.syncDownSettings(nil)
            
            CSSettingsStore.instance.syncDownSettings() { (settings: Settings, succeeded: Bool) in
//                LocationManager.sharedInstance.start()
//                setUserDefaults()
//                checkPackageVersion(settings)
                prefetchInBackground(settings) { success in
                    CSStoreManager.instance.syncUp()
                    appDelegate.timer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: timeDidExpireSelector, userInfo: nil, repeats: true)
                }
            }

            
            
            setupRootViewController()
            

        }
        
        SalesforceSDKManager.shared().launchErrorAction = {
            (error: Error?, launchActionList: SFSDKLaunchAction) in
            if let actualError = error {
                SFLogger.log(.error, msg:"Error during SDK launch: \(actualError.localizedDescription)")
            } else {
                SFLogger.log(.error, msg:"Unknown error during SDK launch.")
            }
            self.initializeAppViewState()
            SalesforceSDKManager.shared().launch()
        }
        SalesforceSDKManager.shared().postLogoutAction = {
            self.handleSdkManagerLogout()
        }
        SalesforceSDKManager.shared().switchUserAction = {
            (fromUser: SFUserAccount?, toUser: SFUserAccount?) -> () in
            self.handleUserSwitch(fromUser, toUser: toUser)
        }


        self.initializeAppViewState();

        SalesforceSDKManager.shared().launch()
 
        
        
        
//        SFRestAPI.sharedInstance().apiVersion = Constants.apiVersion
//        var infoLogLevel: String? = Bundle.main.infoDictionary!["SF_LOG_LEVEL"] as? String
//        if infoLogLevel == nil || (infoLogLevel?.isEmpty)! {
//            infoLogLevel = "Debug"
//        }
//        SFLogger.shared().logLevel = SFLogger.logLevel(for: infoLogLevel!)
//        
//
//        SalesforceSDKManager.shared().postLaunchAction = { (launchAction: SFSDKLaunchAction) -> () in
//            SFLogger.log(SFLogLevel.debug, msg: "postLaunch: launch actions taken: \(launchAction)")
//            completion?()
//
//            SFPushNotificationManager.sharedInstance().registerForRemoteNotifications()
//            registerStores()
//
//            CSSettingsStore.instance.syncDownSettings() { (settings: Settings, succeeded: Bool) in
//                LocationManager.sharedInstance.start()
////                setUserDefaults()
////                checkPackageVersion(settings)
//                prefetchInBackground(settings) { success in
//                    CSStoreManager.instance.syncUp()
//                    appDelegate.timer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: timeDidExpireSelector, userInfo: nil, repeats: true)
//                }
//            }
//        }
//
//        
    }
    
    static func prefetchInBackground(_ settings: Settings, completion: ((Bool) -> Void)? = nil) {
        let beginDate: Date = Date().dateWithMinimumTimeComponents(Calendar.current)
        for store: CSRecordStore in soupsArray {
            CSStoreManager.instance.retrieveStore(store.objectType).prefetch(beginDate, endDate: nil, onCompletion: nil)
        }
        CSPageLayoutStore.instance.prefetch() {success in
            completion?(success)
        }
    }
    
    static var objectList: String {
        return soupsArray.reduce("") {text, store in "\(text)\(store.objectType)," }
        
//        var returnString = ""
//        for store: CSRecordStore in soupsArray {
//            returnString.append(store.objectType)
//            //            returnString.append(CSStoreManager.instance.retrieveStore.objectType)
//        }
//        return returnString
    }

    
    static func getUserId() -> String {
        return SFUserAccountManager.sharedInstance().currentUser!.idData.userId
    }

    static func getAuthToken() -> String {
        return SFUserAccountManager.sharedInstance().currentUser!.credentials.accessToken!
    }
    
//    static func getSessionID(_ completion: ((_ sessionID: String?) -> ())?) {
//        let url = URL(string: "\(SalesforceHelper.getInstanceURL())\(CSStoreManager.instance.endpoint)/\(SFRestAPI.sharedInstance().apiVersion)/sessionID")
//        var request: URLRequest = URLRequest(url: url!)
//        request.setValue("Bearer \(SalesforceHelper.getAuthToken())", forHTTPHeaderField: "Authorization")
//        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//            let sessionID = String(data: data!, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\"", with: "")
//            completion?(sessionID)
//        }.resume()
//    }
//
    static func getInstanceURL() -> URL {
        return SFUserAccountManager.sharedInstance().currentUser!.credentials.instanceUrl!
    }

    static func getUserName() -> String {
        return SFUserAccountManager.sharedInstance().currentUser!.fullName
    }

    @objc fileprivate static func timeDidExpire(_ timer: Timer) {
        CSStoreManager.instance.syncUp()
    }
            //
            //    static func clearSoups() {
            //        for store: CSRecordStore in soupsArray {
            //            store.smartStore.clearSoup(store.objectType)
            //            CSStoreManager.instance.retrieveStore(store.objectType).objectObservable.onNext([])
            //        }
            ////        StatTileStore.instance.smartStore.clearSoup(StatTileStore.instance.objectType)
            ////        postAllChangedNotifications()
            //    }
            //    
    static func registerStores() {
        CSStoreManager.instance.endpoint = Constants.endpoint
        for store: CSRecordStore in soupsArray {
            CSStoreManager.instance.registerStore(store)
        }
    }

    //
//    static func postAllChangedNotifications(_ completion: (() -> ())? = nil) {
//        for notification in changedNotificationsArray {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notification), object: nil)
//        }
//        completion?()
//    }
//    
    
//
//    fileprivate static func checkPackageVersion(_ settings: Settings) {
//        let packageVersion: Version? = Version(string: settings.packageVersion)
//        let expectedVersion: Version? = Version(string: Constants.packageVersion)
//        if expectedVersion != nil && packageVersion != nil && expectedVersion! > packageVersion! {
//            let title: String = SFLocalizedString("UPGRADE_REQUIRED", "").localizedUppercase
//            let text: String = SFLocalizedString("USE_SALESFORCE_PACKAGE_X", "")
//            let detail: String = String(format: text, arguments: [Constants.packageVersion])
//            let message: Message = Message.forError(title: title, detail: detail, url: nil)
//            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.DisplayDetailMessageNotification), object: nil, userInfo: message.userInfo)
//        }
//    }
//    
    fileprivate static func setUserDefaults() {
        let language: String = SFUserAccountManager.sharedInstance().currentUser!.idData.language
        let locale: String = SFUserAccountManager.sharedInstance().currentUser!.idData.locale
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.set(locale, forKey: "AppleLocale")
        UserDefaults.standard.synchronize()
    }

    static func handleSdkManagerLogout()
    {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let window: UIWindow? = appDelegate.window

        SFLogger.log(.debug, msg: "SFAuthenticationManager logged out.  Resetting app.")
        self.resetViewState { () -> () in
            self.initializeAppViewState()
            
            // Multi-user pattern:
            // - If there are two or more existing accounts after logout, let the user choose the account
            //   to switch to.
            // - If there is one existing account, automatically switch to that account.
            // - If there are no further authenticated accounts, present the login screen.
            //
            // Alternatively, you could just go straight to re-initializing your app state, if you know
            // your app does not support multiple accounts.  The logic below will work either way.
            
            var numberOfAccounts : Int;
            let allAccounts = SFUserAccountManager.sharedInstance().allUserAccounts() 
            if allAccounts != nil {
                numberOfAccounts = allAccounts!.count;
            } else {
                numberOfAccounts = 0;
            }
            
            if numberOfAccounts > 1 {
                let userSwitchVc = SFDefaultUserManagementViewController(completionBlock: {
                    action in
                    window?.rootViewController!.dismiss(animated: true, completion: nil)
                })
                window?.rootViewController!.present(userSwitchVc!, animated: true, completion: nil)
            } else {
                if (numberOfAccounts == 1) {
                    SFUserAccountManager.sharedInstance().currentUser = allAccounts![0]
                }
                SalesforceSDKManager.shared().launch()
            }
        }
    }
    
    static func handleUserSwitch(_ fromUser: SFUserAccount?, toUser: SFUserAccount?)
    {
        let fromUserName = (fromUser != nil) ? fromUser?.userName : "<none>"
        let toUserName = (toUser != nil) ? toUser?.userName : "<none>"
        SFLogger.log(.debug, msg:"SFUserAccountManager changed from user \(fromUserName!) to \(toUserName!).  Resetting app.")
        self.resetViewState { () -> () in
            self.initializeAppViewState()
            SalesforceSDKManager.shared().launch()
        }
    }

    static func initializeAppViewState()
    {
        if (!Thread.isMainThread) {
            DispatchQueue.main.async {
                self.initializeAppViewState()
            }
            return
        }
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let window: UIWindow? = appDelegate.window
        window?.rootViewController = UIViewController(nibName: nil, bundle: nil)
        window?.makeKeyAndVisible()
    }
    
    static func setupRootViewController()
    {
        let storyboard: UIStoryboard  = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateInitialViewController()
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let window: UIWindow? = appDelegate.window
        window?.rootViewController = mainViewController
    }
    
    static func resetViewState(_ postResetBlock: @escaping () -> ())
    {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let window: UIWindow? = appDelegate.window

        if let rootViewController = window?.rootViewController {
            if let _ = rootViewController.presentedViewController {
                rootViewController.dismiss(animated: false, completion: postResetBlock)
                return
            }
        }
        postResetBlock()
    }
}
