//
//  PageSelectCityActions.swift
//  YiMaiPatient
//
//  Created by why on 2016/12/23.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageSelectCityActions: PageJumpActions {
    var TargetView: PageSelectCityBodyView!
    var CityApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        TargetView = Target as! PageSelectCityBodyView
        
        CityApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_CITIES, success: GetCitySuccess, error: GetCityError)
    }
    
    func GetCitySuccess(data: NSDictionary?) {
        let hotCities = data!["hot_citys"] as! [[String: AnyObject]]
//        let provinces = data!["provinces"] as! [[String:AnyObject]]
        let cities = data!["citys"] as! [[String: AnyObject]]
        TargetView.LoadData(hotCities, cities: cities)
        TargetView.FullPageLoading.Hide()
    }
    
    func GetCityError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func CityTouched(gr: UITapGestureRecognizer) {
        let cell = gr.view as! YMLabel
        let selected = TargetView.SetCityCellStatus(cell)
        if(selected) {
            TargetView.UpdateSelectedCity(cell.text!)
        } else {
            TargetView.UpdateSelectedCity("尚未选择")
        }
    }
    
    func SaveCityTouched(_: YMButton) {
        TargetView.SelectedCityConfirm = TargetView.SelectedCity
        NavController?.popViewControllerAnimated(true)
    }
}






