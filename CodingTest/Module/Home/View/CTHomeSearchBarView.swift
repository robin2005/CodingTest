//
//  CTHomeSearchBarView.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import UIKit

class CTHomeSearchBarView: CTBaseView {
    lazy var searchBtn: UIButton = bulidButton()
    lazy var textField: UITextField = bulidTextFiled()

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.width, height: 60)
    }
}

extension CTHomeSearchBarView {
    override func initUI() {
        super.initUI()
        backgroundColor = Asset.Colors.viewSubBgColor.color
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubview(searchBtn)
        addSubview(textField)
    }

    override func remakeConstraints() {
        super.remakeConstraints()
        searchBtn.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize(width: 60, height: 40))
            maker.centerY.equalToSuperview()
            maker.right.equalTo(-16)
        }
        textField.snp.remakeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(16)
            maker.top.equalTo(20)
            maker.right.equalTo(searchBtn.snp.left).offset(-16)
        }
    }
}

extension CTHomeSearchBarView {
    func bulidTextFiled() -> UITextField {
        let textField = UITextField()
        textField.textColor = Asset.Colors.textColor.color
        textField.font = CTFont.title17.font
        textField.placeholder = "Please input content"
        return textField
    }

    func bulidButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("Search", for: .normal)
        return button
    }
}
