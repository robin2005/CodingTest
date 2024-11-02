//
//  CTPermissionUtils.swift
//  CodIngTestt-SwiftUI
//
//  Created by jdm on 11/1/24.
//

import AVFoundation
import CoreLocation
import Foundation
import Photos
import UIKit

public typealias CTGrantPermissionCallBack = ((_ type: CTGrantPermissionResult) -> Void)?

public enum CTGrantPermissionResult {
    case authorized
    case denied
    case limited
}

public enum CTPermissionResult {
    case notDetermined
    case authorized
    case denied
    case limited
}

public class CTPermissionUtils: NSObject, CLLocationManagerDelegate {
    // MARK: - Variables

    private var _locationManager = CLLocationManager()
    private var _locationResult: CTGrantPermissionCallBack = nil

    // MAKR: - Init

    override public init() {
        super.init()
        _locationManager.delegate = self
    }

    // MARK: - Permissions

    public func hasLocationPermission() -> CTPermissionResult {
        switch _locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .denied, .restricted:
            return .denied
        default:
            return .notDetermined
        }
    }

    public func grantLocationPermission(_ result: CTGrantPermissionCallBack) {
        _locationResult = result
        _locationManager.requestAlwaysAuthorization()
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch hasLocationPermission() {
        case .authorized, .limited, .notDetermined:
            _locationResult?(.authorized)
        case .denied:
            _locationResult?(.denied)
        }
    }

    public static func hasSystemNotificationPermissions(callBack: ((_ isOK: Bool) -> Void)?) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            var hasSystemNotification = true
            if settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined {
                hasSystemNotification = false
            }
            DispatchQueue.main.async {
                callBack?(hasSystemNotification)
            }
        }
    }

    func grantNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            granted, error in
            if !granted || error != nil {
                print("Authorization to deliver notifications was rejected.")
            }
        }
    }
}

public class CTAvailability: NSObject {
    public class func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
}
