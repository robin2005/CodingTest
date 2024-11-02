//
//  CTHomeBottomBarView.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import UIKit

class CTHomeBottomBarView: CTBaseView {
    lazy var addressLbl: UILabel = bulidLabel(CTFont.title18.font, Asset.Colors.textColor.color)
    lazy var goBtn: UIButton = bulidButton("Go here")
    lazy var radiusUIView = UIView()

    override var intrinsicContentSize: CGSize {
        let height = addressLbl.sizeThatFits(CGSize(width: UIScreen.width - 32, height: CGFLOAT_MAX)).height
        return CGSize(width: UIScreen.width, height: height + 60)
    }
}

extension CTHomeBottomBarView {
    override func initUI() {
        super.initUI()
        isHidden = true
        backgroundColor = Asset.Colors.viewBgColor.color
        radiusUIView.backgroundColor = Asset.Colors.viewSubBgColor.color
        addSubview(addressLbl)
        addSubview(radiusUIView)
        radiusUIView.addSubview(goBtn)
    }

    override func remakeConstraints() {
        super.remakeConstraints()
        addressLbl.snp.remakeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(16)
            maker.left.equalTo(16)
        }

        radiusUIView.snp.remakeConstraints { maker in
            maker.bottom.left.centerX.equalToSuperview()
            maker.top.equalTo(addressLbl.snp.bottom).offset(16)
            maker.height.equalTo(60 + UIScreen.bottom)
        }

        goBtn.snp.remakeConstraints { maker in
            maker.top.equalTo(16)
            maker.left.equalTo(16)
            maker.right.equalTo(-16)
            maker.height.equalTo(44)
        }

        radiusUIView.addCorner(cornerRadii: CornerRadii(topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0))
    }
}

extension CTHomeBottomBarView {
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
