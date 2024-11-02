//
//  CTNotificationUtils.swift
//  CodingTest
//
//  Created by jdm on 11/2/24.
//

import Foundation

enum CTNotificationUtils: String {
    case network = "CodingTest.NetWork"
}

extension CTNotificationUtils {
    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: .init(self.rawValue), object: object)
    }

    func addObserver(observer: Any, selector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .init(self.rawValue), object: object)
    }

    func removeObserver(observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
