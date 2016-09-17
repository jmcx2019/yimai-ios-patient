//
//  PageHospitalSearchActions.swift
//  YiMai
//
//  Created by why on 16/6/15.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class PageHospitalSearchActions: PageJumpActions {
    private var TargetView: PageHospitalSearchBodyView? = nil
    private var HospitalsByCity: YMAPIUtility? = nil
    private var HospitalsByKey: YMAPIUtility? = nil
    
    private func GetHospitalsByCity(data: NSDictionary?) {
        TargetView?.DrawHospitals(data)
    }
    
    private func GetHospitalsError(error: NSError) {
        let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
    }
    
    private func GetHospitalsByKey(data: NSDictionary?) {
        TargetView?.DrawHospitals(data)
    }
    
    override func ExtInit() {
        TargetView = self.Target as? PageHospitalSearchBodyView
        HospitalsByCity = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_HOSPITALS_BY_CITY_LIST,
                                  success: GetHospitalsByCity,
                                  error: GetHospitalsError)
        
        HospitalsByKey = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_HOSPITALS_BY_KEY_LIST,
                                      success: GetHospitalsByKey,
                                      error: GetHospitalsError)
    }

    public func StartSearch(textEditor: YMTextField) {
        let searchKey = textEditor.text
        
        if(YMValueValidator.IsEmptyString(searchKey!)) {
            return
        }
        
        TargetView?.ClearList()
        HospitalsByKey?.YMSearchHospital(searchKey!)
    }
    
    public func HospitalSelected(cell: YMTableViewCell) {
        PageHospitalSearchBodyView.HospitalSelected = cell.CellData
        self.NavController?.popViewControllerAnimated(true)
    }

    public func InitHospitalList() {
        HospitalsByCity?.YMGetHospitalsByCity("1")
    }
}



















