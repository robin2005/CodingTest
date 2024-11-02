//
//  CTDetailBottomBarView.swift
//  CodingTest
//
//  Created by jdm on 11/1/24.
//

import UIKit

class CTDetailBottomBarView: CTBaseView {
    lazy var tripTimeLbl: UILabel = bulidLabel(CTFont.title18.font, Asset.Colors.textColor.color)
    lazy var distanceLbl: UILabel = bulidLabel(CTFont.title18.font, Asset.Colors.textColor.color)
    lazy var backBtn: UIButton = bulidButton("Back")
    lazy var radiusUIView = UIView()

    var detailModel: CTGuidanceDetailModel? {
        didSet {
            tripTimeLbl.text = "Elapsed trip time : \((detailModel?.time ?? 0).timeFormat())"
            distanceLbl.text = "Total distance traveled : \((detailModel?.distance ?? 0).kmFormat())"
            layoutIfNeeded()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.width, height: 32 + 44 + 60 + UIScreen.bottom)
    }
}

extension CTDetailBottomBarView {
    override func initUI() {
        super.initUI()
        backgroundColor = Asset.Colors.viewBgColor.color
        radiusUIView.backgroundColor = Asset.Colors.viewSubBgColor.color
        addSubview(tripTimeLbl)
        addSubview(distanceLbl)
        addSubview(radiusUIView)
        radiusUIView.addSubview(backBtn)
    }

    override func remakeConstraints() {
        super.remakeConstraints()
        tripTimeLbl.snp.remakeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(16)
            maker.left.equalTo(16)
            maker.height.equalTo(22)
        }

        distanceLbl.snp.remakeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(tripTimeLbl.snp.bottom).offset(16)
            maker.left.equalTo(16)
            maker.height.equalTo(22)
        }

        radiusUIView.snp.remakeConstraints { maker in
            maker.bottom.left.centerX.equalToSuperview()
            maker.top.equalTo(distanceLbl.snp.bottom).offset(16)
            maker.height.equalTo(60 + UIScreen.bottom)
        }

        backBtn.snp.remakeConstraints { maker in
            maker.top.equalTo(16)
            maker.left.equalTo(16)
            maker.right.equalTo(-16)
            maker.height.equalTo(44)
        }

        radiusUIView.addCorner(cornerRadii: CornerRadii(topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0))
    }
}

extension CTDetailBottomBarView {
    func bulidLabel(_ font: UIFont?, _ color: UIColor) -> UILabel {
        let lab = UILabel()
        lab.textColor = Asset.Colors.textColor.color
        lab.font = font
        lab.backgroundColor = .clear
        lab.numberOfLines = 0
        return lab
    }

    func bulidButton(_ title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = Asset.Colors.buttonColor.color
        button.setTitle(title, for: .normal)
        button.setTitleColor(Asset.Colors.textColor.color, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        return button
    }

    func bulidIconButton(_ title: String, _ icon: UIImage) -> UIButton {
        let attri: [NSAttributedString.Key: Any] = [.font: CTFont.title16.font ?? UIFont.systemFont(ofSize: 13), .foregroundColor: Asset.Colors.textColor.color]
        let attributedString = NSAttributedString(string: title, attributes: attri)
        var configuration = UIButton.Configuration.plain()
        configuration.image = icon
        configuration.titleAlignment = .center
        configuration.imagePlacement = .top
        configuration.imagePadding = 4
        configuration.attributedTitle = AttributedString(attributedString)
        return UIButton(configuration: configuration)
    }
}
