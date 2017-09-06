//
//  ApexSyncDownTarget.swift
//  Pods
//
//  Created by David Vieser on 4/21/17.
//  Copyright © 2017 Salesforce, Inc. All rights reserved.
//

import Foundation
import SmartSync

public let kApexSyncDownTargetId = "Id";
public let kApexSyncDownTargetPath = "path";
public let kApexSyncDownTargetQueryParams = "queryParams";
public let kApexSyncDownTargetEndpoint = "endpoint";

@objc(ApexSyncDownTarget)
class ApexSyncDownTarget: SFSyncDownTarget {
    
    private var path: String
    private var queryParams: [AnyHashable:Any]
    public var endpoint: String
    
    override public init!(dict: [AnyHashable : Any]!) {
        path = dict[kApexSyncDownTargetPath] as! String
        queryParams = (dict[kApexSyncDownTargetQueryParams] as! Dictionary?) ?? [AnyHashable:Any]()
        endpoint = dict[kApexSyncDownTargetEndpoint] as! String
        super.init(dict: dict)
        queryType = .custom
    }
    
    override func asDict() -> NSMutableDictionary {
        let dict: NSMutableDictionary = super.asDict()
        dict[kSFSyncTargetiOSImplKey] = String(describing: type(of: self))
        dict[kApexSyncDownTargetPath] = path
        dict[kApexSyncDownTargetQueryParams] = queryParams
        dict[kApexSyncDownTargetEndpoint] = endpoint
        return dict
    }
    
    static func newSyncTarget(_ path: String, endpoint: String? = nil, queryParams: [AnyHashable : Any]!) -> ApexSyncDownTarget {
        let dict: [AnyHashable : Any] = [kApexSyncDownTargetPath : path, kApexSyncDownTargetQueryParams : queryParams, kApexSyncDownTargetEndpoint : endpoint ?? ""]
        return ApexSyncDownTarget(dict: dict)
    }
    
    override func startFetch(_ syncManager: SFSmartSyncSyncManager!, maxTimeStamp: Int64, errorBlock: SFSyncDownTargetFetchErrorBlock!, complete completeBlock: SFSyncDownTargetFetchCompleteBlock!) {
        
        SFLogger.log(SFLogLevel.debug, msg: "ApexSyncDownTarget request")
        
        if let queryParams = self.queryParams as? [String: String] {
            let request = SFRestRequest(method: .GET, path: path, queryParams: queryParams)
            request.endpoint = endpoint

            request.setHeaderValue(SFRestAPI.userAgentString("SmartSync"), forHeaderName: kUserAgentPropKey)
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                SFLogger.log(SFLogLevel.error, msg: "CSRestSyncDownFile request failed: \(String(describing: error?.localizedDescription))")
                errorBlock(error)
            }, complete: { [weak self] (response) in
                if let array = response as? NSArray {
                    self?.totalSize = UInt(array.count);
                    completeBlock(array as? [Any]);
                    SFLogger.log(SFLogLevel.debug, msg: "CSRestSyncDownFile request success - ARRAY")
                } else if let dictionary = response as? Dictionary<AnyHashable, Any> {
                    if dictionary[kApexSyncDownTargetId] != nil {
                        self?.totalSize = 1
                        completeBlock([dictionary])
                    } else {
                        let error = NSError(domain:"apex", code:100, userInfo: ["msg" : "Missing Salesforce Id"])
                        errorBlock(error)
                    }
                } else {
                    let error = NSError(domain:"apex", code:100, userInfo: ["msg" : "Invalid Response Type"])
                    errorBlock(error)
                }
            })
            
/*      This code should replace the code above but fails because of a logging issue in Smart Sync Network Utils
             
            SFSmartSyncNetworkUtils.sendRequest(withSmartSyncUserAgent: request, fail: { (error) in
                SFLogger.log(SFLogLevel.error, msg: "CSRestSyncDownFile request failed: \(String(describing: error?.localizedDescription))")
                errorBlock(error)
            }) { [weak self] (response) in
                if let array = response as? NSArray {
                    self?.totalSize = UInt(array.count);
                    completeBlock(array as? [Any]);
                    SFLogger.log(SFLogLevel.debug, msg: "CSRestSyncDownFile request success - ARRAY")
                } else if let dictionary = response as? Dictionary<AnyHashable, Any> {
                    if dictionary[kApexSyncDownTargetId] != nil {
                        self?.totalSize = 1
                        completeBlock([dictionary])
                    } else {
                        let error = NSError(domain:"apex", code:100, userInfo: ["msg" : "Missing Salesforce Id"])
                        errorBlock(error)
                    }
                } else {
                    let error = NSError(domain:"apex", code:100, userInfo: ["msg" : "Invalid Response Type"])
                    errorBlock(error)
                }
            }
 */
        }
    }
}
