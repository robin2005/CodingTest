
//
//  CTHomeViewModel.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import CoreLocation
import GoogleMaps
import GoogleNavigation
import GooglePlaces
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
    lazy var placeResults: BehaviorRelay<[GMSPlace]> = BehaviorRelay(value: [])
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
}

extension CTHomeViewModel {
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completionHandler: @escaping GMSReverseGeocodeCallback) {
        geocoder.reverseGeocodeCoordinate(coordinate, completionHandler: completionHandler)
    }

    func searchByKeyword(_ keyword: String, _ location: CLLocationCoordinate2D) {
        let myProperties = [GMSPlaceProperty.name, GMSPlaceProperty.coordinate].map { $0.rawValue }
        let request = GMSPlaceSearchByTextRequest(textQuery: keyword, placeProperties: myProperties)
        let callback: GMSPlaceSearchNearbyResultCallback = { [weak self] results, error in
            guard let self, error == nil else {
                if let error {
                    CTLog.info(error.localizedDescription)
                }
                return
            }
            guard let results = results else {
                return
            }
            self.placeResults.accept(results)
        }
        GMSPlacesClient.shared().searchByText(with: request, callback: callback)
    }
}
