//
//  CTGuidanceDetailModel.swift
//  CodingTest
//
//  Created by jdm on 11/1/24.
//

import GoogleNavigation

// 导航线路数据
struct CTGuidanceDetailModel: Codable {
    // 起点
    var origin = CTGuidanceDetailPoint()
    // 终点
    var destination = CTGuidanceDetailPoint()
    // 总时间
    var time: TimeInterval = 0
    // 总距离
    var distance: CLLocationDistance = 0
    // 线路字符串
    var path: String = ""
}

struct CTGuidanceDetailPoint: Codable {
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    var title = ""

    func toCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D {
    func toDetailPoint() -> CTGuidanceDetailPoint {
        return CTGuidanceDetailPoint(latitude: latitude, longitude: longitude)
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
}
