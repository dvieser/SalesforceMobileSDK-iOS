//
//  Theme.swift
//  FieldService
//
//  Created by Jason Wells on 10/7/15.
//  Copyright © 2015 Salesforce Services. All rights reserved.
//

import Foundation
import SwiftyJSON
import DesignSystem

class Theme: CSTheme {
    
    let missingColor = UIColor.orange
    
    enum Name: String {
        case accentColor = "fv_THEME_Accent_Primary_Color__c"
        case textColor = "fv_THEME_Text_Color__c"
        case hintColor = "fv_THEME_Hint_Color__c"
        case separatorColor = "fv_THEME_Separator_Color__c"
        case backgroundColor = "fv_THEME_Background_Color__c"
        case navigationBarColor = "fv_THEME_NavBar_Color__c"
        case tabBarColor = "fv_THEME_TabBar_Color__c"
        case positiveColor = "fv_THEME_Positive_Color__c"
        case neutralColor = "fv_THEME_Neutral_Color__c"
        case negativeColor = "fv_THEME_Negative_Color__c"
        case actionableItemColor = "fv_THEME_ActionItem_Color__c"
        case alternateTextColor = "fv_THEME_AltText_Color__c"
        case oppositeTextColor = "fv_THEME_OppText_Color__c"
        case modalTopNavigationBarColor = "fv_THEME_ModalTopNavBar_Color__c"
        case modalTopNavigationButtonTextColor = "fv_THEME_ModalTopNavButton_Color__c"
        case modalBackgroundColor = "fv_THEME_ModalBgColor__c"
        case modalBottomToolbarBackgroundColor = "fv_THEME_ModalBottomToolBar_Color__c"
        case modalBottomToolbarButtonTextColor = "fv_THEME_ModalBottomNavButton_Color__c"
        case topNavigationBarColor = "fv_THEME_TopNavBar_Color__c"
        case navigationBarTextColor = "fv_THEME_NavBarText_Color__c"
        case tabBarTextColor = "fv_THEME_TabBarText_Color__c"
        case tabBarIconColor = "fv_THEME_TabBarIcon_Color__c"
        case borderColor = "fv_THEME_Border_Color__c"
        case shadowColor = "fv_THEME_Shadow_Color__c"
        case lightShadowColor = "fv_THEME_LightShadow_Color__c"
    }
    
    //CSTheme defined
    fileprivate(set) lazy var textColor: UIColor = self.parseColor(Name.textColor.rawValue)
    fileprivate(set) lazy var accentColor: UIColor = self.parseColor(Name.accentColor.rawValue)
    fileprivate(set) lazy var hintColor: UIColor = self.parseColor(Name.hintColor.rawValue)
    fileprivate(set) lazy var separatorColor: UIColor = self.parseColor(Name.separatorColor.rawValue)
    fileprivate(set) lazy var backgroundColor: UIColor = self.parseColor(Name.backgroundColor.rawValue)
    fileprivate(set) lazy var navigationBarColor: UIColor = self.parseColor(Name.navigationBarColor.rawValue)
    fileprivate(set) lazy var tabBarColor: UIColor = self.parseColor(Name.tabBarColor.rawValue)
    fileprivate(set) lazy var positiveColor: UIColor = self.parseColor(Name.positiveColor.rawValue)
    fileprivate(set) lazy var neutralColor: UIColor = self.parseColor(Name.neutralColor.rawValue)
    fileprivate(set) lazy var negativeColor: UIColor = self.parseColor(Name.negativeColor.rawValue)
    
    fileprivate(set) lazy var headingFont: UIFont = UIFont.sldsFontStrong(with: .medium)
    fileprivate(set) lazy var subheadingFont: UIFont = UIFont.sldsFontLight(with: .small)
    fileprivate(set) lazy var hintFont: UIFont = UIFont.sldsFontLight(with: .small)
    fileprivate(set) lazy var bodyFont: UIFont = UIFont.sldsFontRegular(with: SLDSFontSizeType.small)
    fileprivate(set) lazy var detailFont: UIFont = UIFont.sldsFontRegular(with: SLDSFontSizeType.xSmall)
    fileprivate(set) lazy var labelFont: UIFont = UIFont.sldsFontLight(with: .medium)
    fileprivate(set) lazy var tabFont: UIFont = UIFont.sldsFontLight(with: .xSmall)
    
    //App defined
    fileprivate(set) lazy var actionableItemColor: UIColor = self.parseColor(Name.actionableItemColor.rawValue)
    fileprivate(set) lazy var alternateTextColor: UIColor = self.parseColor(Name.alternateTextColor.rawValue)
    fileprivate(set) lazy var oppositeTextColor: UIColor = self.parseColor(Name.oppositeTextColor.rawValue)
    
    fileprivate(set) lazy var modalTopNavigationBarColor : UIColor  = self.parseColor(Name.modalTopNavigationBarColor.rawValue)
    fileprivate(set) lazy var modalTopNavigationButtonTextColor: UIColor  = self.parseColor(Name.modalTopNavigationButtonTextColor.rawValue)
    fileprivate(set) lazy var modalBackgroundColor: UIColor  = self.parseColor(Name.modalBackgroundColor.rawValue)
    fileprivate(set) lazy var modalBottomToolbarBackgroundColor: UIColor  = self.parseColor(Name.modalBottomToolbarBackgroundColor.rawValue)
    fileprivate(set) lazy var modalBottomToolbarButtonTextColor: UIColor  = self.parseColor(Name.modalBottomToolbarButtonTextColor.rawValue)
    
    fileprivate(set) lazy var clearBackgroundColor: UIColor = UIColor.clear
    fileprivate(set) lazy var shadowColor: UIColor = self.parseColor(Name.shadowColor.rawValue)
    fileprivate(set) lazy var lightShadowColor: UIColor = self.parseColor(Name.lightShadowColor.rawValue)
    
    fileprivate(set) lazy var topNavigationBarColor: UIColor = self.parseColor(Name.topNavigationBarColor.rawValue)
    fileprivate(set) lazy var navigationBarTextColor: UIColor = self.parseColor(Name.navigationBarTextColor.rawValue)
    
    fileprivate(set) lazy var tabBarTextColor: UIColor = self.parseColor(Name.tabBarTextColor.rawValue)
    fileprivate(set) lazy var tabBarIconColor: UIColor = self.parseColor(Name.tabBarIconColor.rawValue)
    
    fileprivate(set) lazy var borderColor: UIColor = self.parseColor(Name.borderColor.rawValue)
    
    
    fileprivate(set) lazy var regularXSmall: UIFont = UIFont.sldsFontRegular(with: .xSmall)
    fileprivate(set) lazy var regularSmall: UIFont = UIFont.sldsFontRegular(with: .small)
    fileprivate(set) lazy var regularMedium: UIFont = UIFont.sldsFontRegular(with: .medium )
    fileprivate(set) lazy var regularLarge: UIFont = UIFont.sldsFontRegular(with: .large)
    fileprivate(set) lazy var regularXLarge: UIFont = UIFont.sldsFontRegular(with: .xLarge)
    fileprivate(set) lazy var regularXXLarge: UIFont = UIFont.sldsFontRegular(with: .xxLarge)
    
    fileprivate(set) lazy var lightXSmall: UIFont = UIFont.sldsFontLight(with: .xSmall)
    fileprivate(set) lazy var lightSmall: UIFont = UIFont.sldsFontLight(with: .small)
    fileprivate(set) lazy var lightMedium: UIFont = UIFont.sldsFontLight(with: .medium )
    fileprivate(set) lazy var lightLarge: UIFont = UIFont.sldsFontLight(with: .large)
    fileprivate(set) lazy var lightXLarge: UIFont = UIFont.sldsFontLight(with: .xLarge)
    fileprivate(set) lazy var lightXXLarge: UIFont = UIFont.sldsFontLight(with: .xxLarge)
    
    fileprivate(set) lazy var strongXSmall: UIFont = UIFont.sldsFontStrong(with: .xSmall)
    fileprivate(set) lazy var strongSmall: UIFont = UIFont.sldsFontStrong(with: .small)
    fileprivate(set) lazy var strongMedium: UIFont = UIFont.sldsFontStrong(with: .medium )
    fileprivate(set) lazy var strongLarge: UIFont = UIFont.sldsFontStrong(with: .large)
    fileprivate(set) lazy var strongXLarge: UIFont = UIFont.sldsFontStrong(with: .xLarge)
    fileprivate(set) lazy var strongXXLarge: UIFont = UIFont.sldsFontStrong(with: .xxLarge)
    
    fileprivate var json: JSON
    
    init(json: JSON) {
        self.json = json
    }

    fileprivate func parseColor(_ property: String) -> UIColor {
        if let hex: String = json[property].string {
            return UIColor(hex: hex)
        }
        return missingColor
    }
}
