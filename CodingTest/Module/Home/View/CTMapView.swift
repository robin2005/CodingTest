//
//  CTMapView.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import GoogleMaps
import GoogleNavigation

class CTMapView: GMSMapView {
    lazy var selectMaker: GMSMarker = buildMaker(Asset.Icons.maker.image)
    private var locationManager = CLLocationManager()

    var destination: CLLocationCoordinate2D? {
        didSet {
            configMaker()
        }
    }

    convenience init(_ frame: CGRect) {
        let options = GMSMapViewOptions()
        options.frame = frame
        self.init(options: options)
        self.isMyLocationEnabled = true
    }
}

extension CTMapView {
    func buildMaker(_ icon: UIImage?) -> GMSMarker {
        let maker = GMSMarker(position: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        maker.icon = icon
        return maker
    }
}

extension CTMapView {
    // 配置选择标记
    func configMaker() {
        guard let destination = destination else {
            selectMaker.map = nil
            return
        }
        selectMaker.map = self
        selectMaker.position = destination
    }

    // 配置路由点
    func getDestinations() -> [GMSNavigationWaypoint] {
        guard let origin = myLocation?.coordinate,
              let destination = destination,
              let destinationPoint = GMSNavigationWaypoint(location: destination, title: ""),
              let originPoint = GMSNavigationWaypoint(location: origin, title: "")
        else { return [] }
        return [destinationPoint, originPoint]
    }

    // 开始导航
    func startGuidance(_ callBack: ((GMSRouteStatus) -> Void)?) {
        let destinations = getDestinations()
        guard destinations.count == 2, let nav = navigator, let provider = roadSnappedLocationProvider else {
            callBack?(.noRouteFound)
            return
        }
        locationManager.requestAlwaysAuthorization()
        isNavigationEnabled = true
        nav.setDestinations(destinations) { [weak self] status in
            self?.destinationsCallBack(status)
            callBack?(status)
        }
        provider.startUpdatingLocation()
        provider.allowsBackgroundLocationUpdates = true
        selectMaker.map = nil
    }

    //  路由状态回调
    func destinationsCallBack(_ status: GMSRouteStatus) {
        if status == .OK {
            navigator?.isGuidanceActive = true
            cameraMode = .following
        } else {
            stopGuidance()
        }
    }

    //  停止导航
    func stopGuidance() {
        selectMaker.map = nil
        isNavigationEnabled = false
        navigator?.isGuidanceActive = false
        navigator?.clearDestinations()
        roadSnappedLocationProvider?.stopUpdatingLocation()
        cameraMode = .following
        showCurLocation()
    }

    //  显示我的位置
    func showCurLocation() {
        guard let coordinate = myLocation?.coordinate else { return }
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        animate(to: camera)
    }

    //  地图放大
    func zoomIn() {
        let cameraUpdate = GMSCameraUpdate.zoomIn()
        animate(with: cameraUpdate)
    }

    //  地图缩小
    func zoomOut() {
        let cameraUpdate = GMSCameraUpdate.zoomOut()
        animate(with: cameraUpdate)
    }

    //  根据线路信息显示线路，起点终点
    func showRoutes(_ detailModel: CTGuidanceDetailModel?) {
        clear()
        guard let detailModel = detailModel else { return }
        let path = detailModel.mutablePath
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = Asset.Colors.buttonColor.color
        polyline.strokeWidth = 5
        polyline.map = self

        if path.count() >= 2 {
            let origin = path.coordinate(at: 0)
            let destination = path.coordinate(at: path.count() - 1)
            let camera = GMSCameraPosition.camera(withTarget: origin, zoom: 15)
            animate(to: camera)
            let origintMaker: GMSMarker = buildMaker(Asset.Icons.origin.image)
            origintMaker.position = origin
            origintMaker.title = detailModel.originTitle
            origintMaker.map = self
            let destinationMaker: GMSMarker = buildMaker(Asset.Icons.destination.image)
            destinationMaker.position = destination
            destinationMaker.map = self
            destinationMaker.title = detailModel.destinationTitle
        }
    }
}
