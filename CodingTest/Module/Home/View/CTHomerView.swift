//
//  CTHomeView.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import CoreLocation
import GoogleMaps
import GoogleNavigation
import NSObject_Rx
import RxCocoa
import RxSwift
import Toast
import UIKit

// MARK: - 视图事件模型

enum CTHomeViewEventType {
    case goGuidanceDetail(_ model: CTGuidanceDetailModel)
    case reverseGeocodeByDestination(_ coordinate: CLLocationCoordinate2D)
    case reverseGeocodeByOrigin(_ coordinate: CLLocationCoordinate2D)
    case travelModeChange
    case none
}

class CTHomeView: CTBaseView {
    private lazy var mapView = bulidMapView()
    private lazy var bottomBar = CTHomeBottomBarView()
    private lazy var rightMenuBar = CTHomerMenuBarView()
    private lazy var loadingView = CTHomeLoadingView()

    var eventModel: BehaviorRelay<CTHomeViewEventType> = BehaviorRelay(value: .none)

    var travelMode: BehaviorRelay<GMSNavigationTravelMode> = BehaviorRelay(value: .walking)
    private var isGuidance: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    private var detailModel = CTGuidanceDetailModel()
    private var preNavState: GMSNavigationNavState?
    var originAddress: GMSAddress?
    var selectAddress: GMSAddress? {
        didSet {
            configSelectMarker()
        }
    }
}

extension CTHomeView {
    override func initUI() {
        super.initUI()

        addSubview(mapView)
        addSubview(bottomBar)
        addSubview(loadingView)
        addSubview(rightMenuBar)
        configEvent()
        copnfigSubscribe()
    }

    override func remakeConstraints() {
        mapView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        bottomBar.snp.remakeConstraints { maker in
            maker.centerX.left.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        rightMenuBar.snp.remakeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.right.equalTo(-16)
        }
        loadingView.snp.remakeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.left.equalToSuperview()
        }
    }
}

extension CTHomeView {
    // 创建地图控件控件
    func bulidMapView() -> CTMapView {
        let mapView = CTMapView(bounds)
        mapView.delegate = self
        if let navigator = mapView.navigator, let roadSnappedLocationProvider = mapView.roadSnappedLocationProvider {
            navigator.add(self)
            roadSnappedLocationProvider.add(self)
        }
        return mapView
    }
}

extension CTHomeView {
    // 配置视图事件
    func configEvent() {
        rightMenuBar.zoomIn.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        rightMenuBar.zoomOut.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        rightMenuBar.myLocation.addTarget(self, action: #selector(showCurLocation), for: .touchUpInside)
        bottomBar.goBtn.addTarget(self, action: #selector(startGuidance), for: .touchUpInside)
        rightMenuBar.closeBtn.addTarget(self, action: #selector(stopGuidance), for: .touchUpInside)
        rightMenuBar.travelModeBtn.addTarget(self, action: #selector(travelModeChange), for: .touchUpInside)
    }

    // 配置订阅事件
    func copnfigSubscribe() {
        isLoading.subscribe(onNext: { [weak self] isLoading in
            isLoading ? self?.loadingView.startAnimating() : self?.loadingView.stopAnimating()
        }).disposed(by: rx.disposeBag)

        travelMode.subscribe(onNext: { [weak self] travelMode in
            self?.mapView.travelMode = travelMode
        }).disposed(by: rx.disposeBag)

        isGuidance.subscribe(onNext: { [weak self] isGuidance in
            if isGuidance {
                self?.bottomBar.isHidden = true
                self?.rightMenuBar.closeBtn.isHidden = false
                self?.rightMenuBar.travelModeBtn.isHidden = true
                self?.detailModel = CTGuidanceDetailModel()
                if let coordinate = self?.mapView.myLocation?.coordinate {
                    self?.detailModel.origin = coordinate.toDetailPoint()
                }
            } else {
                self?.rightMenuBar.closeBtn.isHidden = true
                self?.rightMenuBar.travelModeBtn.isHidden = false
            }
        }).disposed(by: rx.disposeBag)
    }
}

extension CTHomeView {
    // 导航模式
    @objc func travelModeChange() {
        eventModel.accept(.travelModeChange)
    }

    // 导航详情
    @objc func goGuidanceDetail() {
        guard let currentRouteLeg = mapView.navigator?.currentRouteLeg else { return }
        detailModel.path = currentRouteLeg.path?.encodedPath() ?? ""
        detailModel.destination = currentRouteLeg.destinationCoordinate.toDetailPoint()
        detailModel.origin.title = originAddress?.lines?.joined(separator: " ") ?? ""
        detailModel.destination.title = selectAddress?.lines?.joined(separator: " ") ?? ""
        eventModel.accept(.goGuidanceDetail(detailModel))
        stopGuidance()
    }

    // 开始导航
    @objc func startGuidance() {
        isGuidance.accept(true)
        isLoading.accept(true)
        mapView.startGuidance { [weak self] status in
            self?.isLoading.accept(false)
            self?.isGuidance.accept(status == .OK)
            if status != .OK {
                self?.makeToast(status.message())
            }
            CTLog.info("startGuidance call back \(status) \(status.message())!")
        }
        CTLog.info("startGuidance")
    }

    // 结束导航
    @objc func stopGuidance() {
        isGuidance.accept(false)
        mapView.stopGuidance()
        isLoading.accept(false)
        selectAddress = nil
        makeToast("Navigation ends")
        CTLog.info("stopGuidance")
    }

    // 放大
    @objc func zoomIn() {
        mapView.zoomIn()
    }

    // 缩小
    @objc func zoomOut() {
        mapView.zoomOut()
    }

    // 显示我的位置
    @objc func showCurLocation() {
        mapView.showCurLocation()
        if !isGuidance.value {
            guard let coordinate = mapView.myLocation?.coordinate else { return }
            eventModel.accept(.reverseGeocodeByOrigin(coordinate))
        }
        CTLog.info("showCurLocation")
    }

    func configSelectMarker() {
        guard let selectAddress = selectAddress else {
            bottomBar.isHidden = true
            mapView.destination = nil
            return
        }
        bottomBar.isHidden = false
        mapView.destination = selectAddress.coordinate
        bottomBar.addressLbl.text = selectAddress.lines?.joined(separator: "\n")
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: - GMSMapViewDelegate

extension CTHomeView: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if !isGuidance.value {
            eventModel.accept(.reverseGeocodeByDestination(position.target))
        }
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if !isGuidance.value {
            eventModel.accept(.reverseGeocodeByDestination(coordinate))
        }
    }
}

// MARK: - GMSNavigatorListener

extension CTHomeView: GMSNavigatorListener {
    // 接收目标时间更新
    func navigator(_ navigator: GMSNavigator, didUpdateRemainingTime time: TimeInterval) {
        CTLog.info("didUpdateRemainingTime at \(time)!")
    }

    // 正在接收到目的地的距离更新
    func navigator(_ navigator: GMSNavigator, didUpdateRemainingDistance distance: CLLocationDistance) {
        CTLog.info("didUpdateRemainingDistance at \(distance)!")
    }

    // 检测到达事件
    func navigator(_ navigator: GMSNavigator, didArriveAt waypoint: GMSNavigationWaypoint) {
        preNavState = nil
        goGuidanceDetail()
    }

    // 检测到达事件
    func navigator(_ navigator: GMSNavigator, didUpdate navInfo: GMSNavigationNavInfo) {
        if navInfo.navState != preNavState {
            detailModel.time += navInfo.currentStep?.timeFromPrevStepSeconds ?? 0
            detailModel.distance += navInfo.currentStep?.distanceFromPrevStepMeters ?? 0
            preNavState = navInfo.navState
            CTLog.info("didUpdate navInfo at \(navInfo.navState.rawValue) ")
            CTLog.info("currentStep : \(navInfo.currentStep?.description ?? "")")
        }
    }
}

// MARK: - GMSRoadSnappedLocationProviderListener

extension CTHomeView: GMSRoadSnappedLocationProviderListener {
    func locationProvider(_ locationProvider: GMSRoadSnappedLocationProvider, didUpdate location: CLLocation) {
        let info = String(format: "Road snapped location: (%.8f, %.8f)", location.coordinate.latitude, location.coordinate.longitude)
        CTLog.info(info)
    }
}
