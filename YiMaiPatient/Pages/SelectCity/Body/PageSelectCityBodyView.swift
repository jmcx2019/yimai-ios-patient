//
//  PageSelectCityBodyView.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/14.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

public class PageSelectCityBodyView: PageBodyView{
    private var CitiesDict: NSDictionary? = nil
    
    override func ViewLayout() {
        super.ViewLayout()
        LoadCitiesFromPList()
        DrawCityList()
    }
    
    func LoadCitiesFromPList() {
        let path = NSBundle.mainBundle().bundlePath
        let cityList = "cityDictionary.plist"
        
        let finalPath:String = (path as NSString).stringByAppendingPathComponent(cityList)
        self.CitiesDict = NSDictionary(contentsOfFile:finalPath)
    }
    
    func DrawCityList() {

        var cityListPanel = [UIView?]()
        
        for _ in 0...25 {
            cityListPanel.append(nil)
        }
        
        print(cityListPanel.count)

        let alphaIndex: [String: Int] = [
            "A":0,
            "B":1,
            "C":2,
            "D":3,
            "E":4,
            "F":5,
            "G":6,
            "H":7,
            "I":8,
            "J":9,
            "K":10,
            "L":11,
            "M":12,
            "N":13,
            "O":14,
            "P":15,
            "Q":16,
            "R":17,
            "S":18,
            "T":19,
            "U":20,
            "V":21,
            "W":22,
            "X":23,
            "Y":24,
            "Z":25
        ]

        for cityArrayByAlpha in CitiesDict! {
            print(cityArrayByAlpha.key)
            let key = cityArrayByAlpha.key as! String
//            print(alphaIndex[key])
            let cities = cityArrayByAlpha.value as! Array<String>

            for city in cities.enumerate() {
//                print(city.element)
            }
        }
    }
}