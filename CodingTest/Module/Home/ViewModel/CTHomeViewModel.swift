
//
//  CTHomeViewModel.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import CoreLocation
import GoogleMaps
import GoogleNavigation
import Reachability
import RxRelay

// ViewModel 事件回调
enum CTHomeViewModelEventType {
    case none
    case showCurLocation
}

class CTHomeViewModel: ALOBaseViewModel {
    lazy var permission = CTPermissionUtils()
    lazy var geocoder = GMSGeocoder()
    lazy var eventModel: BehaviorRelay<CTHomeViewModelEventType> = BehaviorRelay(value: .none)
    lazy var netStatus: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var reachability: Reachability?
}

// MARK: - Permissions

extension CTHomeViewModel {
    // 是否存在GPS权限
    func hasLocationPermission() -> CTPermissionResult {
        return permission.hasLocationPermission()
    }

    // GPS申请授权
    func grantLocationPermission(_ result: CTGrantPermissionCallBack = nil) {
        permission.grantLocationPermission(result)
    }

    // 是否存在通知权限
    func grantNotificationPermission() {
        permission.grantNotificationPermission()
    }

    // Google协议弹框
    func showTermsAndConditionsDialogIfNeeded() {
        let termsAndConditionsOptions = GMSNavigationTermsAndConditionsOptions(companyName: "CodingTest Co.")
        GMSNavigationServices.showTermsAndConditionsDialogIfNeeded(with: termsAndConditionsOptions) { [weak self] termsAccepted in
            if termsAccepted {
                if self?.hasLocationPermission() != .authorized {
                    self?.grantLocationPermission { [weak self] type in
                        if type != .denied {
                            self?.grantNotificationPermission()
                        } else {
                            self?.eventModel.accept(.showCurLocation)
                        }
                    }
                } else {
                    self?.eventModel.accept(.showCurLocation)
                }
            }
        }
    }

    // 网络监听
    func startNotifier() {
        do {
            reachability = try? Reachability(hostname: "google.com")
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
            try reachability?.startNotifier()
        } catch {
            CTLog.info("无法启动通知")
        }
    }

    // 关闭监听
    func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }

    // 监听通知
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            CTLog.info("通过WiFi连接")
        case .cellular:
            CTLog.info("通过蜂窝网络连接")
        case .unavailable:
            CTLog.info("网络不可达")
        }
        netStatus.accept(reachability.connection != .unavailable)
    }
}

// # Mark - 地理位置反编码
extension CTHomeViewModel {
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completionHandler: @escaping GMSReverseGeocodeCallback) {
        geocoder.reverseGeocodeCoordinate(coordinate, completionHandler: completionHandler)
    }
}
