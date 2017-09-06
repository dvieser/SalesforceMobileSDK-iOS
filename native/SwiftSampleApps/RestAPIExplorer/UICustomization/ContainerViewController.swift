//
//  ContainerViewController.swift
//  FieldVisit
//
//  Created by Nicholas McDonald on 3/13/17.
//  Copyright © 2017 Salesforce, Inc. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import RxSwift

class ContainerViewController: BaseViewController {

//    @IBOutlet weak var accountsButton: UIButton!
//    @IBOutlet weak var visitsButton: UIButton!
//    @IBOutlet weak var mapButton: UIButton!
//    @IBOutlet weak var preferencesButton: UIButton!
//
//    @IBOutlet weak var circleCollectionView: UICollectionView!
//    
//    @IBOutlet weak var graphView: GraphView!
//    
//    lazy var logoItem = UIBarButtonItem()
//    lazy var logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 63, height: 45))
//
//    let circleCollectionViewName = "CircleCollectionViewCell"
//    var circleViewData: [CircleViewData] = []
//    let disposeBag = DisposeBag()
//    
//    private let showAccountSegueId = "ShowAccountViewControllerSeque"
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let nib: UINib = UINib(nibName: circleCollectionViewName, bundle: nil)
//        circleCollectionView.register(nib, forCellWithReuseIdentifier: circleCollectionViewName)
//        
//        logoItem.customView = logoImageView
//        logoImageView.contentMode = .scaleAspectFit
//        navigationItem.leftBarButtonItem = logoItem
//        
////        AccountStore.instance.showInspector(self)
//        
//        _ = Observable.combineLatest(VisitStore.instance.objectObservable, CSSettingsStore.instance.settingsObservable) { (visit, settings) in
//            guard settings != nil else { return }
//            DispatchQueue.main.async {
//                self.populateCircleView()
//            }
//        }.subscribe()
//        
//        _ = CSSettingsStore.instance.settingsObservable.asObservable().subscribe( onNext: { [weak self] settings in
//            DispatchQueue.main.async {
//                guard settings != nil else { return }
//                self?.populateGraphView()
//            }
//        })
//    }
//
//    override func apply(settings: Settings) {
//        super.apply(settings: settings)
//        mapButton.isHidden = !settings.showMapTab
//        logoImageView.appImageFromId(settings.logoImageId, placeHolderImage: UIImage(named: "SalesforceLogo"), usePersistantCache: true)
//        accountsButton.setTitleColor(settings.theme.textColor, for: .normal)
//        visitsButton.setTitleColor(settings.theme.textColor, for: .normal)
//        mapButton.setTitleColor(settings.theme.textColor, for: .normal)
//        preferencesButton.setTitleColor(settings.theme.textColor, for: .normal)
//    }
//    
//    func populateGraphView() {
//        let graphData = [100.5, 101.3, 102.6, 102.0, 103.5, 103.9, 104.0, 104.5, 104.4, 105.0]
//        graphView.data = graphData
//    }
//    
//    func populateCircleView() {
//        circleViewData = [VisitStore.instance.queryVisitsComplete(),
//                          AccountStore.instance.queryMyAccounts(),
//                          AttachmentStore.instance.queryTotalAttachments(),
//        ]
//        circleCollectionView.reloadData()
//    }
}
//
//extension ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return circleViewData.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell: CircleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: circleCollectionViewName, for: indexPath) as! CircleCollectionViewCell
//        cell.circleView.data = circleViewData[indexPath.item]
//        return cell
//    }
//}
