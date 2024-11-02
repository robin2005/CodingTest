//
//  CTHomeMenuBarView.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import UIKit

class CTHomeMenuBarView: CTBaseView {
    // 放大一个等级
    lazy var zoomIn: UIButton = bulidIconButton(Asset.Icons.zoomIn.image)
    // 缩小一个等级
    lazy var zoomOut: UIButton = bulidIconButton(Asset.Icons.zoomOut.image)
    // 我的位置
    lazy var myLocation: UIButton = bulidIconButton2(Asset.Icons.myPosition.image)
    // 退出
    lazy var closeBtn: UIButton = bulidIconButton2(Asset.Icons.close.image)
    // 导航模式
    lazy var travelModeBtn: UIButton = bulidIconButton2(Asset.Icons.menu.image)

    lazy var radiusBGView = bulidBGView()

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 180)
    }
}

extension CTHomeMenuBarView {
    override func initUI() {
        super.initUI()
        backgroundColor = .clear
        radiusBGView.addSubview(zoomIn)
        radiusBGView.addSubview(zoomOut)
        addSubview(radiusBGView)
        addSubview(myLocation)
        addSubview(closeBtn)
        addSubview(travelModeBtn)
        closeBtn.isHidden = true
        travelModeBtn.isHidden = true
    }

    override func remakeConstraints() {
        radiusBGView.snp.remakeConstraints { maker in
            maker.centerX.top.equalToSuperview()
            maker.size.equalTo(CGSize(width: 40, height: 80))
        }
        zoomIn.snp.remakeConstraints { maker in
            maker.centerX.top.equalToSuperview()
            maker.size.equalTo(CGSize(width: 40, height: 40))
        }

        zoomOut.snp.remakeConstraints { maker in
            maker.centerX.bottom.equalToSuperview()
            maker.size.equalTo(CGSize(width: 40, height: 40))
        }

        myLocation.snp.remakeConstraints { maker in
            maker.top.equalTo(radiusBGView.snp.bottom).offset(10)
            maker.centerX.equalToSuperview()
            maker.size.equalTo(CGSize(width: 40, height: 40))
        }

        closeBtn.snp.remakeConstraints { maker in
            maker.centerX.bottom.equalToSuperview()
            maker.size.equalTo(CGSize(width: 40, height: 40))
        }

        travelModeBtn.snp.remakeConstraints { maker in
            maker.edges.equalTo(closeBtn)
        }
    }
}

extension CTHomeMenuBarView {
    func bulidBGView() -> UIView {
        let radiusBGView = UIView()
        radiusBGView.backgroundColor = Asset.Colors.viewSubBgColor.color
        radiusBGView.layer.cornerRadius = 5
        radiusBGView.layer.masksToBounds = true
        return radiusBGView
    }

    func bulidIconButton(_ icon: UIImage) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(icon, for: .normal)
        return button
    }

    func bulidIconButton2(_ icon: UIImage) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(icon, for: .normal)
        button.backgroundColor = Asset.Colors.viewSubBgColor.color
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }
}
