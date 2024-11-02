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
        options.camera = GMSCameraPosition(latitude: 1.285, longitude: 103.848, zoom: 12)
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
    func configMaker() {
        guard let destination = destination else {
            selectMaker.map = nil
            return
        }
        selectMaker.map = self
        selectMaker.position = destination
    }

    func getDestinations() -> [GMSNavigationWaypoint] {
        guard let origin = myLocation?.coordinate,
              let destination = destination,
              let destinationPoint = GMSNavigationWaypoint(location: destination, title: ""),
              let originPoint = GMSNavigationWaypoint(location: origin, title: "")
        else { return [] }
        return [destinationPoint, originPoint]
    }

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

    func destinationsCallBack(_ status: GMSRouteStatus) {
        if status == .OK {
            navigator?.isGuidanceActive = true
            cameraMode = .following
        } else {
            stopGuidance()
        }
    }

    func stopGuidance() {
        selectMaker.map = nil
        isNavigationEnabled = false
        navigator?.isGuidanceActive = false
        navigator?.clearDestinations()
        roadSnappedLocationProvider?.stopUpdatingLocation()
        cameraMode = .following
        showCurLocation()
    }

    func showCurLocation() {
        guard let coordinate = myLocation?.coordinate else { return }
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        animate(to: camera)
    }

    func zoomIn() {
        let cameraUpdate = GMSCameraUpdate.zoomIn()
        animate(with: cameraUpdate)
    }

    func zoomOut() {
        let cameraUpdate = GMSCameraUpdate.zoomOut()
        animate(with: cameraUpdate)
    }

    func showRoutes(_ detailModel: CTGuidanceDetailModel?) {
        clear()
        guard let path = GMSPath(fromEncodedPath: detailModel?.path ?? "") else { return }
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = Asset.Colors.buttonColor.color
        polyline.strokeWidth = 5
        polyline.map = self

        guard let origin = detailModel?.origin.toCoordinate2D(),
              let destination = detailModel?.destination.toCoordinate2D() else { return }
        let camera = GMSCameraPosition.camera(withTarget: origin, zoom: 15)
        animate(to: camera)
        let origintMaker: GMSMarker = buildMaker(Asset.Icons.origin.image)
        origintMaker.position = origin
        origintMaker.title = detailModel?.origin.title
        origintMaker.map = self
        let destinationMaker: GMSMarker = buildMaker(Asset.Icons.destination.image)
        destinationMaker.position = destination
        destinationMaker.map = self
        destinationMaker.title = detailModel?.destination.title
    }
}
