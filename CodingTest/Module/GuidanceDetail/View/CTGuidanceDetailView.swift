//
//  CTGuidanceDetailView.swift
//  CodingTest
//
//  Created by jdm on 11/1/24.
//

import GoogleNavigation
import RxRelay

enum CTGuidanceDetailViewEventType {
    case none
    case back
}

class CTGuidanceDetailView: CTBaseView {
    private lazy var mapView = bulidMapView()
    private lazy var rightMenuBar = CTHomerMenuBarView()
    private lazy var bottomBar = CTDetailBottomBarView()
    var eventModel: BehaviorRelay<CTGuidanceDetailViewEventType> = BehaviorRelay(value: .none)

    var detailModel: CTGuidanceDetailModel? {
        didSet {
            bottomBar.detailModel = detailModel
            showRoutes()
        }
    }
}

extension CTGuidanceDetailView {
    override func initUI() {
        super.initUI()

        addSubview(mapView)
        addSubview(rightMenuBar)
        addSubview(bottomBar)
        configEvent()
    }

    override func remakeConstraints() {
        mapView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        rightMenuBar.snp.remakeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.right.equalTo(-16)
        }
        bottomBar.snp.remakeConstraints { maker in
            maker.centerX.left.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
}

extension CTGuidanceDetailView {
    // 创建地图控件控件
    func bulidMapView() -> CTMapView {
        let mapView = CTMapView(bounds)
        return mapView
    }
}

extension CTGuidanceDetailView {
    // 配置视图事件
    func configEvent() {
        rightMenuBar.zoomIn.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        rightMenuBar.zoomOut.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        rightMenuBar.myLocation.addTarget(self, action: #selector(showCurLocation), for: .touchUpInside)
        bottomBar.backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
}

extension CTGuidanceDetailView {
    // 返回
    @objc func back() {
        eventModel.accept(.back)
    }

    // 显示线路
    @objc func showRoutes() {
        mapView.showRoutes(detailModel)
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
    }
}
