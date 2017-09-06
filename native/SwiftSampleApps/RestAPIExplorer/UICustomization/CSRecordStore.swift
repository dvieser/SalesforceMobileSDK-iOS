//
//  CSRecordStore.swift
//  CSMobileBase
//
//  Created by Jason Wells on 6/28/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation
import SmartStore
import SmartSync
import RxSwift

open class CSRecordStore {

    private let parentString = "Parent"
    
    public typealias RecordCompletionBlock<R> = ([R], Bool) -> Void
    public typealias QueryBuilderBlock = ((CSQueryBuilder) -> (CSQueryBuilder))
    
    public let dateFormatter: DateFormatter = DateFormatter()
    open let semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    public final var smartSync: SFSmartSyncSyncManager {
        let store: SFSmartStore = smartStore
        return SFSmartSyncSyncManager.sharedInstance(for: store)!
    }
    
    public final var smartStore: SFSmartStore {
        let store: SFSmartStore = SFSmartStore.sharedStore(withName: kDefaultSmartStoreName) as! SFSmartStore
        SFSyncState.setupSyncsSoupIfNeeded(store)
        if store.soupExists(objectType) == false {
            do {
                let soupSpec: SFSoupSpec = SFSoupSpec.newSoupSpec(objectType, withFeatures: soupFeatures)
                let indexSpecs: [AnyObject] = SFSoupIndex.asArraySoupIndexes(indexes) as [AnyObject]
                try store.registerSoup(with: soupSpec, withIndexSpecs: indexSpecs)
            } catch let error as NSError {
                SFLogger.log(SFLogLevel.error, msg: "\(objectType) failed to register soup: \(error.localizedDescription)")
            }
        }
        return store
    }
    
    public func showInspector(_ inViewController:UIViewController) {
        let inspector = SFSmartStoreInspectorViewController(store: self.smartStore)
        inViewController.present(inspector!, animated: false, completion: nil)
    }
    
    open var objectType: String
    open var soupFeatures: [Any]
    open var limit: UInt { return 350 }
    open var objectObservable: BehaviorSubject<[CSRecord?]> = BehaviorSubject(value: [])
    
    open var indexes: [[String:String]] {
        let object: CSObject? = CSSettingsStore.instance.read().object(objectType)
        let nameField: String = object?.nameField ?? CSRecord.Field.id.rawValue
        var indexes: [[String:String]] = [["path" : CSRecord.Field.id.rawValue, "type" : kSoupIndexTypeString]]
        indexes.append(["path" : CSRecord.Field.externalId.rawValue, "type" : kSoupIndexTypeString])
        indexes.append(["path" : nameField, "type" : kSoupIndexTypeString])
        indexes.append(["path" : "__local__", "type" : kSoupIndexTypeInteger])
        indexes.append(["path" : "__locally_deleted__", "type" : kSoupIndexTypeInteger])
        indexes.append(["path" : "__locally_created__", "type" : kSoupIndexTypeInteger])
        for searchField: String in object?.searchFields ?? [] {
            indexes.append(["path" : searchField, "type" : kSoupIndexTypeFullText])
        }
        return indexes
    }
    
    lazy var child: CSRecordStore? = CSStoreManager.instance.retrieveStore(self.objectType)
    
    open var masters: [CSRecordStore] { return [] }
    
    open var readFields: CSFieldSet {
        if let object: CSObject = CSSettingsStore.instance.read().object(objectType) {
            return CSFieldSet.forRead()
                .withObject(object)
                .withField(CSRecord.Field.id.rawValue)
                .withField(CSRecord.Field.externalId.rawValue)
                .withField(object.nameField ?? CSRecord.Field.id.rawValue)
        }
        return CSFieldSet.forRead().withField(CSRecord.Field.id.rawValue)
    }
    
    open var writeFields: CSFieldSet {
        if let object: CSObject = CSSettingsStore.instance.read().object(objectType) {
            return CSFieldSet.forWrite()
                .withObject(object)
        }
        return CSFieldSet.forWrite()
    }
    
    open var createFields: CSFieldSet {
        if let object: CSObject = CSSettingsStore.instance.read().object(objectType) {
            return CSFieldSet.forCreate()
                .withObject(object)
        }
        return CSFieldSet.forCreate()
    }
    
    open var updateFields: CSFieldSet {
        if let object: CSObject = CSSettingsStore.instance.read().object(objectType) {
            return CSFieldSet.forUpdate()
                .withObject(object)
        }
        return CSFieldSet.forUpdate()
    }
    
    public func hasIndexSpecs(_ indexSpecs: [AnyObject]) -> Bool {
        if indexSpecs.count != smartStore.indices(forSoup: objectType).count {
            return false
        }
        var dictionary: [String : [String]] = [:]
        for index: AnyObject in smartStore.indices(forSoup: objectType) as [AnyObject] {
            if let soupIndex: SFSoupIndex = index as? SFSoupIndex {
                if dictionary[soupIndex.path] != nil {
                    dictionary[soupIndex.path]!.append(soupIndex.indexType)
                }
                else {
                    dictionary[soupIndex.path] = [soupIndex.indexType]
                }
            }
        }
        for index: AnyObject in indexSpecs {
            if let soupIndex: SFSoupIndex = index as? SFSoupIndex {
                if let indexTypes: [String] = dictionary[soupIndex.path] {
                    if indexTypes.contains(soupIndex.indexType) == false {
                        return false
                    }
                }
                else {
                    return false
                }
            }
        }
        return true
    }
    
    required public init(objectType: String) {
        self.objectType = objectType
        self.soupFeatures = []
    }
    
    open func indexStore() {
        if smartStore.soupExists(objectType) {
            let indexSpecs: [AnyObject] = SFSoupIndex.asArraySoupIndexes(indexes) as [AnyObject]
            if hasIndexSpecs(indexSpecs) == false {
                smartStore.alterSoup(objectType, withIndexSpecs: indexSpecs, reIndexData: true)
                SFLogger.log(SFLogLevel.debug, msg: "\(objectType) updating indices")
            }
        }
    }
    
    open func cleanStore(_ query: String, offset: Int = 0) {
        do {
            let querySpec: SFQuerySpec = SFQuerySpec.newSmartQuerySpec(query, withPageSize: limit)
            let pageIndex: UInt = UInt(ceil(Double(offset) / Double(limit)))
            let entries: [AnyObject] = try smartStore.query(with: querySpec, pageIndex: pageIndex) as [AnyObject]
            smartStore.removeEntries(entries, fromSoup: objectType)
        } catch let error as NSError {
            SFLogger.log(SFLogLevel.error, msg: "\(objectType) failed to clean store: \(error.localizedDescription)")
        }
    }
    
    open func expireStore() {
        do {
            let calendar: Calendar = Calendar.current
            let options: NSCalendar.Options = NSCalendar.Options(rawValue: 0)
            let date: Date = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: -14, to: Date(), options: options)!
            let timestamp: String = Int64(date.timeIntervalSince1970 * 1000).description
            let query: String = "SELECT {\(self.objectType):_soupEntryId} FROM {\(self.objectType)} WHERE {\(self.objectType):__local__} = 0 AND {\(self.objectType):_soupLastModifiedDate} < \(timestamp)"
            let querySpec: SFQuerySpec = SFQuerySpec.newSmartQuerySpec(query, withPageSize: 1000000)
            let entries: [AnyObject] = try smartStore.query(with: querySpec, pageIndex: 0) as [AnyObject]
            smartStore.removeEntries(entries, fromSoup: objectType)
        } catch let error as NSError {
            SFLogger.log(SFLogLevel.error, msg: "\(objectType) failed to expire store: \(error.localizedDescription)")
        }
    }
    
    open func queryStore<R: CSRecord>(_ query: String, offset: Int = 0) -> [R] {
        do {
            let querySpec: SFQuerySpec = SFQuerySpec.newSmartQuerySpec(query, withPageSize: limit)
            let pageIndex: UInt = UInt(ceil(Double(offset) / Double(limit)))
            let entries: [AnyObject] = try smartStore.query(with: querySpec, pageIndex: pageIndex) as [AnyObject]
            let dictionaries: [NSDictionary] = entries.map { return ($0 as! [NSDictionary])[0] }
            return dictionaries.map{ R(dictionary: $0) }
        } catch let error as NSError {
            SFLogger.log(SFLogLevel.error, msg: "\(objectType) failed to query store: \(error.localizedDescription)")
        }
        return []
    }
    
    open func queryStore(_ query: String) -> Int {
        do {
            let querySpec: SFQuerySpec = SFQuerySpec.newSmartQuerySpec(query, withPageSize: 1)
            let entries: [[Int]] = try smartStore.query(with: querySpec, pageIndex: 0) as! [[Int]]
            return entries.first?.first ?? 0
        } catch let error as NSError {
            SFLogger.log(SFLogLevel.error, msg: "\(objectType) failed to query store: \(error.localizedDescription)")
        }
        return 0
    }
    
    open func refresh<R: CSRecord>(_ record: R) -> R {
        let entry: [String : AnyObject] = record.toStoreEntry()
        if let soupEntryId: AnyObject = entry["_soupEntryId"] {
            let entries: [AnyObject] = smartStore.retrieveEntries([soupEntryId], fromSoup: objectType) as [AnyObject]
            if let dictionary: NSDictionary = entries.first as? NSDictionary {
                return R(dictionary: dictionary)
            }
        }
        return record
    }
    
    open func create<R: CSRecord>(_ record: R) -> R {
        record.setInteger("__local__", value: 1)
        record.setInteger("__locally_created__", value: 1)
        record.setInteger("__locally_updated__", value: 0)
        record.setInteger("__locally_deleted__", value: 0)
        let entries: [AnyObject] = smartStore.upsertEntries([record.toStoreEntry()], toSoup: objectType) as [AnyObject]
        if let dictionary: NSDictionary = entries.first as? NSDictionary {
            let record = R(dictionary: dictionary)
            child?.objectObservable.onNext([record])
            return record
        }
        child?.objectObservable.onNext([record])
        return record
    }
    
    open func update<R: CSRecord>(_ record: R) -> R {
        record.setInteger("__local__", value: 1)
        //        record.setInteger("__locally_created__", value: 0)
        record.setInteger("__locally_updated__", value: 1)
        record.setInteger("__locally_deleted__", value: 0)
        let entries: [AnyObject] = smartStore.upsertEntries([record.toStoreEntry()], toSoup: objectType) as [AnyObject]
        if let dictionary: NSDictionary = entries.first as? NSDictionary {
            let record = R(dictionary: dictionary)
            child?.objectObservable.onNext([record])
            return record
        }
        return record
    }
    
    open func delete<R: CSRecord>(_ record: R) {
        record.setInteger("__local__", value: 1)
        record.setInteger("__locally_created__", value: 0)
        record.setInteger("__locally_updated__", value: 0)
        record.setInteger("__locally_deleted__", value: 1)
        smartStore.upsertEntries([record.toStoreEntry()], toSoup: objectType)
        child?.objectObservable.onNext([])
    }
    
    open func syncDown(_ target: SFSyncDownTarget, onCompletion: @escaping (Bool, String) -> Void) {
        let timestamp: String = Int64(Date().timeIntervalSince1970 * 1000).description
        let options: SFSyncOptions = SFSyncOptions.newSyncOptions(forSyncDown: SFSyncStateMergeMode.leaveIfChanged)
        smartSync.syncDown(with: target, options: options, soupName: objectType, update: { (syncState: SFSyncState?) in
            if let syncState = syncState {
                if syncState.isDone() || syncState.hasFailed() {
                    if syncState.hasFailed() {
                        SFLogger.log(SFLogLevel.error, msg: "syncDown \(self.objectType) failed")
                    }
                    else {
                        SFLogger.log(SFLogLevel.debug, msg: "syncDown \(self.objectType) returned \(syncState.totalSize)")
                    }
                    onCompletion(syncState.hasFailed() == false, timestamp)
                }
            }
        })
    }
    
    open func read<R: CSRecord>(_ queryFilters: @escaping (QueryBuilderBlock)) -> [R] {
        let records: [R] = read(queryFilters: queryFilters, offset: 0, onCompletion: nil)
        return records
    }
    
    open func read<R: CSRecord>(queryFilters: QueryBuilderBlock? = nil, offset: Int = 0, onCompletion completion: RecordCompletionBlock<R>? = nil) -> [R] {
        var query: CSQueryBuilder = CSQueryBuilder.forSoupName(objectType)
        //.whereNotNull(CSRecord.Field.id.rawValue)
        
        if let q = queryFilters {
            query = q(query)
        }
        return read(query, offset: offset, onCompletion: completion)
    }
    
    open func read<R: CSRecord>(_ query: CSQueryBuilder, offset: Int = 0, onCompletion completion: RecordCompletionBlock<R>? = nil) -> [R] {
        let records: [R] = self.queryStore(query.buildRead(), offset: offset)
        DispatchQueue.main.async {
            completion?(records, true)
        }
        return records
    }
    
    open func syncUp(_ target: SFSyncUpTarget? = nil, onCompletion completion: ((Bool) -> Void)? = nil) {
        
        let settings: CSSettings = CSSettingsStore.instance.read()

        let referencableObjects = CSStoreManager.instance.storeList + [parentString]
        let referenced: [(String, String, String)] = settings.object(objectType).map { $0.fields }!.filter { $0.type == CSFieldType.Reference && referencableObjects.contains($0.referenceTo ?? "") && $0.referenceTo != objectType }.map { ($0.referenceTo!, $0.relationshipName!, $0.name) }

        if referenced.count == 0 {
            doSyncUp(target, onCompletion: completion)
        }
        
        for (index, (var parentName, var relationshipName, var fieldName)) in referenced.enumerated() {
            if parentName != self.objectType {
                
                if relationshipName == parentString { // NOTES AND ATTACHMENTS
                    fieldName = "ParentId"
                    relationshipName = "Parent__r"
                    parentName = "fv_Visit__c" // HARD CODE FOR NOW - CAN ONLY BE ON VISITS
                }
                let parentRecordStore = CSStoreManager.instance.retrieveStore(parentName)
                
                parentRecordStore.syncUp(target) { success in
                    parentRecordStore.doSyncUp(target) { success in
                        
                        self.readLocallyCreated(parent: parentName, fieldName: fieldName).forEach { record in
                            let parentId = record.getString(fieldName)
                            if let newParent: CSRecord = parentRecordStore.read(forExternalId: parentId) {
                                record.setReference(fieldName, value: newParent, relationshipName: relationshipName)
                                _ = self.update(record)
                            }
                        }
                        if referenced.count - 1 == index {
                            self.doSyncUp(target, onCompletion: completion)
                        }

                    }
                }
            }
        }
    }

    private func doSyncUp(_ target: SFSyncUpTarget? = nil, onCompletion completion: ((Bool) -> Void)? = nil) {
        let updateBlock: SFSyncSyncManagerUpdateBlock = { [unowned self] (syncState: SFSyncState?) in
            if let syncState = syncState {
                if syncState.isDone() || syncState.hasFailed() {
                    self.semaphore.signal()
                    DispatchQueue.main.async {
                        if syncState.hasFailed() {
                            SFLogger.log(SFLogLevel.error, msg: "syncUp \(self.objectType) failed")
                        }
                        else {
                            self.expireStore()
                            SFLogger.log(SFLogLevel.debug, msg: "syncUp \(self.objectType) done")
                        }
                        CSStoreManager.instance.retrieveStore(self.objectType).objectObservable.onNext([])
                        completion?(syncState.hasFailed() == false)
                    }
                }
            }
        }
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
            let options: SFSyncOptions = SFSyncOptions.newSyncOptions(forSyncUp: self.readFields.array)
            if let target: SFSyncUpTarget = target {
                self.smartSync.syncUp(with: target, options: options, soupName: self.objectType, update: updateBlock)
            }
            else {
                let target: SFSyncUpTarget = SFSyncUpTarget(createFieldlist: self.createFields.array, updateFieldlist: self.updateFields.array)
//                    SFSyncUpTarget.newSyncTarget(self.objectType, createFields: self.createFields.set, updateFields: self.updateFields.set)
                self.smartSync.syncUp(with: target, options: options, soupName: self.objectType, update: updateBlock)
            }
        }
    }
    
    private func readLocallyCreated<R: CSRecord>(parent: String, fieldName: String) -> [R] {
        let query = "SELECT {\(objectType):_soup} FROM {\(objectType)}, {\(parent)} WHERE {\(objectType):\(fieldName)} = {\(parent):MobileExternalId__c}"
        let records: [R] = self.queryStore(query, offset: 0)
        return records
    }

    public func read(forExternalId externalID: String?) -> CSRecord? {
        guard externalID != nil else { return nil }
        var query: CSQueryBuilder = CSQueryBuilder.forSoupName(objectType)
        query = query.whereEqual(CSRecord.Field.externalId.rawValue, value: externalID!)
        return read(query).first
    }

    public func refresh(record: CSRecord?) -> CSRecord? {
        guard record != nil && record?.id != nil else { return nil }
        var query: CSQueryBuilder = CSQueryBuilder.forSoupName(objectType)
            .whereEqual(CSRecord.Field.id.rawValue, value: record!.id!)
        if let externalId = record?.externalId {
            query = query.or()
                .whereEqual(CSRecord.Field.externalId.rawValue, value: externalId)
        }
        return read(query).first
    }

    open func createAndSyncUp(_ record: CSRecord, onCompletion completion: ((Void) -> Void)?) -> CSRecord {
        let refreshed: CSRecord = create(record)
        completion?()
        //child?.objectObservable.onNext([refreshed])
        syncUp() { (isSynced: Bool) in
            self.child?.objectObservable.onNext([refreshed])
        }
        return refreshed
    }
    
    open func updateAndSyncUp(_ record: CSRecord, onCompletion completion: ((Void) -> Void)?) -> CSRecord {
        let refreshed: CSRecord = update(record)
        //child?.objectObservable.onNext([record])
        completion?()
        syncUp() { (isSynced: Bool) in
            self.child?.objectObservable.onNext([record])
        }
        return refreshed
    }
    
    open func deleteAndSyncUp(_ record: CSRecord, onCompletion completion: ((Void) -> Void)? = nil) {
        delete(record)
        //child?.objectObservable.onNext([])
        completion?()
        syncUp() { (isSynced: Bool) in
            self.child?.objectObservable.onNext([])
        }
    }
    
    open func prefetch(_ beginDate: Date?, endDate: Date?, onCompletion: ((Bool) -> Void)?) {
        var queryParams: [String : String] = ["fields" : readFields.description]
        if let beginDate: String = dateFormatter.queryString(beginDate) {
            queryParams["beginDate"] = beginDate
        }
        if let endDate: String = dateFormatter.queryString(endDate) {
            queryParams["endDate"] = endDate
        }
        let path: String = "/\(SFRestAPI.sharedInstance().apiVersion)/prefetch/\(objectType.lowercased())"
        let target: ApexSyncDownTarget = ApexSyncDownTarget.newSyncTarget(path, queryParams: queryParams)
        target.endpoint = CSStoreManager.instance.endpoint
        
        let options: SFSyncOptions = SFSyncOptions.newSyncOptions(forSyncDown: SFSyncStateMergeMode.leaveIfChanged)
        smartSync.syncDown(with: target, options: options, soupName: objectType, update: { (syncState: SFSyncState?) in
            if let syncState = syncState {
                if syncState.isDone() || syncState.hasFailed() {
                    if syncState.hasFailed() {
                        SFLogger.log(SFLogLevel.error, msg: "prefetch \(self.objectType) failed")
                    }
                    else {
                        self.child?.objectObservable.onNext(self.read())
                        SFLogger.log(SFLogLevel.debug, msg: "prefetch \(self.objectType) returned \(syncState.totalSize)")
                    }
                    if let onCompletion: ((Bool) -> Void) = onCompletion {
                        DispatchQueue.main.async {
                            onCompletion(syncState.hasFailed() == false)
                        }
                    }
                }
            }
        })
    }

    open func readAndSyncDown<R: CSRecord>(_ record: R? = nil, offset: Int = 0, queryFilters: QueryBuilderBlock? = nil, onCompletion completion: @escaping RecordCompletionBlock<R>) {
        
        let recordId = record?.id
        
        var whereClause: String? = nil
        var query: CSQueryBuilder = CSQueryBuilder.forSoupName(objectType)
            
        if let recordId = recordId {
            query = query.whereEqual(CSRecord.Field.id.rawValue, value: recordId)
            whereClause = "\(CSRecord.Field.id.rawValue) = '\(recordId)'"
        } else {
           //flquery = query.whereNotNull(CSRecord.Field.id.rawValue)
        }
        if let queryFilters = queryFilters {
            query = queryFilters(query)
        }
        
        _ = read(query, onCompletion: completion)
        
        let soql: String = SFRestAPI.soqlQuery(withFields: readFields.array, sObject: objectType, whereClause: whereClause, groupBy: nil, having: nil, orderBy: nil, limit: NSInteger(limit))! + " offset \(offset)"
        let target: SFSoqlSyncDownTarget = SFSoqlSyncDownTarget.newSyncTarget(soql)

        syncDown(target) { (isSynced: Bool, timestamp: String) in
            if isSynced {
                self.cleanStore(query.buildCleanupForDate(timestamp), offset: offset)
            }
            //self.child?.objectObservable.onNext(self.read(query, onCompletion: completion))
            _ = self.read(query, onCompletion: completion)
        }
    }
    
    open func requestAndSyncDown<R: CSRecord>(path: String, queryParams: [AnyHashable: Any]?, onCompletion: @escaping ([R], Bool) -> Void) {
        let target: ApexSyncDownTarget = ApexSyncDownTarget.newSyncTarget(path, queryParams: queryParams)
        target.endpoint = "/services/data"
        
        syncDown(target) { (isSynced: Bool, timestamp: String) in
        }
    }

    open func requestAndSyncDownFileContentsFor(record: CSRecord, onCompletion: @escaping (Bool, String) -> Void) {
        return
        let dictionary: [AnyHashable: Any] = [kId : record.id as Any]
        let target: SFSyncDownTarget = SFSyncDownTarget(dict: dictionary)
        
//        let target: CSRestSyncDownFileTarget = CSRestSyncDownFileTarget.newSyncTarget(dict: dictionary)
        
        syncDown(target) { (isSynced: Bool, timestamp: String) in
            //self.child?.objectObservable.onNext([record])
        }
    }
    
    open func searchAndSyncDown<R: CSRecord>(_ text: String, offset: Int = 0, onCompletion: @escaping ([R], Bool) -> Void) {
        let settings: CSSettings = CSSettingsStore.instance.read()
        if text.characters.count > 1, let object: CSObject = settings.object(objectType) {
            let nameField: String = object.nameField ?? CSRecord.Field.id.rawValue
            let query: CSQueryBuilder = CSQueryBuilder.forSoupName(objectType)
                .orderBy(nameField)
 
            let sosl: String = "FIND {\(text)*} IN ALL FIELDS RETURNING \(objectType)(\(readFields.description) LIMIT \(limit) OFFSET \(offset))"
            let target: SFSoslSyncDownTarget = SFSoslSyncDownTarget.newSyncTarget(sosl)
            syncDown(target) { (isSynced: Bool, timestamp: String) in
                let records: [R] = self.queryStore(query.buildSearchForText(text), offset: offset)
                DispatchQueue.main.async {
                    self.child?.objectObservable.onNext(records)
                    onCompletion(records, isSynced)
                }
            }
        }
        else {
            onCompletion([], false)
        }
    }
    
}
