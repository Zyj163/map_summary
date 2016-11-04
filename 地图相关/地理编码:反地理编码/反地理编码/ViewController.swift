//
//  ViewController.swift
//  反地理编码
//
//  Created by xiaomage on 16/4/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    @IBOutlet weak var addressTV: UITextView!
   
    
    @IBOutlet weak var latitudeTF: UITextField!
    
    @IBOutlet weak var longitudeTF: UITextField!
    
    
    // 需要联网!!!
    
    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    
    // 地理编码  地址 -> 经纬度
    @IBAction func geoCode() {
        
        let addressStr = addressTV.text
        
        geoCoder.geocodeAddressString(addressStr!) { (pls: [CLPlacemark]?, error: NSError?) -> Void in
            if error == nil {
                print("地理编码成功")
                
                guard let plsResult = pls else {return}
                
//                CLPlacemark: 地标对象
                // location: 地标对象对应的位置对象
                // name : 地址详情
                // SHENGDA  盛大 盛达
                let firstPL = plsResult.first
                self.addressTV.text = firstPL?.name
                
                self.latitudeTF.text = "\((firstPL?.location?.coordinate.latitude)!)"
                self.longitudeTF.text = "\((firstPL?.location?.coordinate.longitude)!)"
                
                
            }else {
                print("错误")
            }
        } as! CLGeocodeCompletionHandler
        
        
    }
    
    // 反地理编码  经纬度->地址
    @IBAction func reverseGeoCode() {
        
        
        let latitude = CLLocationDegrees(latitudeTF.text!) ?? 0
        let longitude = CLLocationDegrees(longitudeTF.text!) ?? 0
        
        let loc1 = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(loc1) {
            (pls: [CLPlacemark]?, error: NSError?) -> Void in
            if error == nil {
                print("地理编码成功")
                
                guard let plsResult = pls else {return}
                
                //                CLPlacemark: 地标对象
                // location: 地标对象对应的位置对象
                // name : 地址详情
                // SHENGDA  盛大 盛达
                let firstPL = plsResult.first
                self.addressTV.text = firstPL?.name
                
                self.latitudeTF.text = "\((firstPL?.location?.coordinate.latitude)!)"
                self.longitudeTF.text = "\((firstPL?.location?.coordinate.longitude)!)"
                
                
            }else {
                print("错误")
            }

        } as! CLGeocodeCompletionHandler
        
        
    }
    

}

