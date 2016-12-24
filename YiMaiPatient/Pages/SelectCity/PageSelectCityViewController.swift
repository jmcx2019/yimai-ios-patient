//
//  PageSelectCityViewController.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/14.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit

typealias CitySelected = ((String?, String?) -> Void)

public class PageSelectCityViewController: PageViewController {
    public var BodyView: PageSelectCityBodyView? = nil
    
    static var CitySelectedCallback: CitySelected? = nil

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageSelectCityBodyView(parentView: self.view, navController: self.navigationController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "选择城市", navController: NavController!)
    }

    override func PagePreRefresh() {
        BodyView?.FullPageLoading.Show()
        let cities = YMLocalData.GetData("CitiyList") as? [String: [[String: AnyObject]]]
        let hotCities = YMLocalData.GetData("HotCities") as? [[String: AnyObject]]
        
        if(nil == cities || nil == hotCities) {
            BodyView?.CityActions.CityApi.YMGetCity()
        } else {
            self.BodyView?.SearchFlag = false
            self.BodyView?.SetCityCellStatus(nil)
            if(0 == BodyView?.AllCityCell.count) {
                YMDelay(0.1, closure: {
                    self.BodyView?.DrawSelectedCityPanel()
                    self.BodyView?.DrawHotCityPanel(hotCities!)
                    self.BodyView?.DrawCities(cities!)
                    self.BodyView?.FullPageLoading.Hide()
                })
            } else {
                self.BodyView?.DrawSelectedCityPanel()
                self.BodyView?.FullPageLoading.Hide()
            }
        }

    }

    override func PageDisapeared() {
        var cityName: String? = nil
        var cityId: String? = nil
        if(nil != BodyView?.SelectedCityConfirm) {
            let cityData = BodyView!.SelectedCityConfirm!.UserObjectData as! [String: AnyObject]
            let cityUserData = cityData["userData"] as! [String:AnyObject]
            cityName = YMVar.GetStringByKey(cityUserData, key: "name")
            cityId = YMVar.GetStringByKey(cityUserData, key: "id")
            YMVar.MyInfo["city"] = ["name": cityName!, "id": cityId!]
        }
        PageSelectCityViewController.CitySelectedCallback?(cityName, cityId)
        BodyView?.SelectedCity = nil
        BodyView?.SelectedCityConfirm = nil
        PageSelectCityViewController.CitySelectedCallback = nil
        
        BodyView?.SearchFlag = false
        BodyView?.SearchInput.text = ""
        BodyView?.DoSearch(BodyView!.SearchInput)
    }
}
