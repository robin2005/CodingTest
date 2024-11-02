//
//  CTGuidanceDetailModel.swift
//  CodingTest
//
//  Created by jdm on 11/1/24.
//

import GoogleMaps
import GoogleNavigation

// 导航线路数据
struct CTGuidanceDetailModel {
    // 起点名称
    var originTitle = ""
    // 终点名称
    var destinationTitle = ""
    // 总距离
    var distance: CLLocationDistance = 0
    // 路线
    var mutablePath = GMSMutablePath()
    // 结束
    var end: TimeInterval = 0
    // 开始
    var start: TimeInterval = 0
    // 总时间
    var time: TimeInterval {
        return end - start
    }
}

extension CLLocationCoordinate2D {
    func toString() -> String {
        return "\(latitude)\(longitude)"
    }
}

extension Double {
    // 数字转时间格式
    func timeFormat() -> String {
        if isNaN || isInfinite {
            return "0 s"
        }
        let hour = floor(self / 3600)
        let minute = ((Int(self) % 3600) / 60)
        let sec = Int(self) % 60

        let paddedHour = String(format: "%02d", hour)
        let paddedMinute = String(format: "%02d", minute)
        let paddedSec = String(format: "%02d", sec)
        if hour > 0 {
            return paddedHour + " h " + paddedMinute + " m " + paddedSec + " s "
        } else if minute > 0 {
            return paddedMinute + " m " + paddedSec + " s "
        } else {
            return paddedSec + " s "
        }
    }

    // 数字转时间格式
    func kmFormat() -> String {
        if isNaN || isInfinite {
            return "0 km"
        }
        return String(format: "%0.2f km", self / 1000)
    }

    func isNaN() -> Bool {
        return isNaN || isInfinite
    }
}
