//
//  ViewController.swift
//  LBS
//
//  Created by ddn on 16/7/15.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var lastLoc: CLLocation?
    
    private lazy var locationMgr : CLLocationManager = { [weak self] in
        let locationMgr = CLLocationManager()
        
        locationMgr.delegate = self
        
        if #available(iOS 8.0, *) {
            //前台定位授权（info配置）
            locationMgr.requestWhenInUseAuthorization()
            
            //前后台定位授权（info配置）
            locationMgr.requestAlwaysAuthorization()
        }
        
        //如果是ios8，不需要下面代码，但是要勾选后台定位，会有蓝条出现
        if #available(iOS 9.0, *) {
            //如果当前授权是前台定位，想要在后台定位，要勾选后台定位，并且设置下面代码
            locationMgr.allowsBackgroundLocationUpdates = true
            
            //定位一次，不能和其他启动定位的方式一起用
            locationMgr.requestLocation()
        }
        
        //每隔10米定位一次
        locationMgr.distanceFilter = 10
        //精确度
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        
        
        //根据基站定位（精确度比较低）
//        locationMgr.startMonitoringSignificantLocationChanges()
        
        //判断设备是否关闭了定位服务，系统会自动弹窗
//        CLLocationManager.locationServicesEnabled()
        //获取授权状态
//        CLLocationManager.authorizationStatus()
    
        return locationMgr
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取设备朝向
//        if CLLocationManager.headingAvailable() {
//            locationMgr.startUpdatingHeading()
//        }else {
//            print("当前磁力计设备损坏")
//        }
        
        //区域监听
//        // 1. 创建区域
//        let center = CLLocationCoordinate2DMake(21.123, 121.345)
//        var distance: CLLocationDistance = 1000
//        if distance > locationMgr.maximumRegionMonitoringDistance {
//            distance = locationMgr.maximumRegionMonitoringDistance
//        }
//        let region  = CLCircularRegion(center: center, radius: distance, identifier: "region")
//        // 2. 监听区域
//        locationMgr.startMonitoringForRegion(region)
        
        // 2.1 请求某个区域的状态
//        locationMgr.requestStateForRegion(region)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        locationMgr.startUpdatingLocation()
    }


}

extension ViewController: CLLocationManagerDelegate {
    
//    /// 进入区域时调用
//    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        print("进入区域--" + region.identifier)
//    }
//    
//    // 离开区域时调用
//    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
//        print("离开区域--" + region.identifier)
//    }
    
//    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
//        if region.identifier == "region" {
//            if state == .Inside {
//                print("进入区域--" + region.identifier)
//            }else if state == .Outside {
//                print("离开区域--" + region.identifier)
//            }
//        }
//    }
    
    //指南针
//    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        //角度0-359.9
//        let angle = newHeading.magneticHeading
//        
//        let hudu = CGFloat(angle / 180 * M_PI)
//        
//        //添加动画
//    }
    
    //位置更新
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        //locations中的元素是按时间排序的，所以做后一个是最新的
        guard let newLocation = locations.last else {return}
        if newLocation.horizontalAccuracy < 0 { return }
        
        //horizontalAccuracy 为负代表位置信息无效
        //verticalAccuracy 为负代表海拔信息无效
        //course 航向
        //distanceFromLocation 计算两个经纬度之间的距离
        
        // 1. 获取当前的行走航向
        let angleStrs = ["北偏东", "东偏南", "南偏西", "西偏北"]
        let index = Int(newLocation.course) / 90
        var angleStr = angleStrs[index]
        
        // 2. 行走的偏离角度
        let angle = newLocation.course % 90
        
        if Int(angle) == 0 {
            let index = angleStr.startIndex.advancedBy(1)
            angleStr = "正" + angleStr.substringToIndex(index)
        }
        
        let lastLoaction = lastLoc ?? newLocation
        let distance = newLocation.distanceFromLocation(lastLoaction)
        lastLoc = newLocation
        
        // 4. 合并字符串, 打印
        //        例如:”北偏东 30度 方向,移动了 8米”
        if Int(angle) == 0 {
            print(angleStr + "方向, 移动了\(distance)米")
        }else
        {
            print(angleStr + "\(angle)" + "方向, 移动了\(distance)米")
        }
        
//        manager.stopUpdatingLocation()
    }
    //定位失败
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    //授权状态改变
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print(status)
    }
}










