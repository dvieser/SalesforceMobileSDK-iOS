//
//  BaseViewController.swift
//  FieldVisit
//
//  Created by David Vieser on 3/16/17.
//  Copyright © 2017 Salesforce, Inc. All rights reserved.
//

import UIKit
import RxSwift

protocol ItemSelectedProtocol {
//    func itemSelected(item: CSRecord)
}

class BaseViewController: UIViewController, ItemSelectedProtocol {

//    lazy var settings: Settings = CSSettingsStore.instance.read()
//    
//    internal let createItemSegueName = "CreateItemSeque"
//    internal let itemDetailSegueName = "ItemDetailSegue"
//    internal var itemSelectedDelegate: ItemSelectedProtocol?
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        itemSelectedDelegate = self
//    }
//
//    func itemSelected(item: CSRecord) {
//        return
//    }
//
////    lazy var notificationCenter: NotificationCenter = NotificationCenter.default
////    fileprivate let settingsDidChange: Selector = #selector(ContainerViewController.settingsDidChange(_:))
////
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        _ = CSSettingsStore.instance.settingsObservable.asObservable().subscribe(onNext: { settings in
//            DispatchQueue.main.async {
//                if let settings = settings as? Settings {
//                    self.apply(settings: settings)
//                }
//            }
//        })
//    }
//        
////        apply(settings: settings)
////        notificationCenter.removeThenAddObserver(self, selector: settingsDidChange, name: Constants.SettingsChangedNotification, object: nil)
////
////    @objc func settingsDidChange(_ notification: Notification) {
////        if let settings: Settings = notification.object as? Settings {
////            DispatchQueue.main.async {
////                self.apply(settings: settings)
////            }
////        }
////    }
////    
//    open func apply(settings: Settings) {
//        view.backgroundColor = settings.theme.backgroundColor
//    }
////    
////    deinit {
////        notificationCenter.removeObserver(self)
////    }
}
