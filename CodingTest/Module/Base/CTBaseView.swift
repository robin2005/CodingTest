//
//  CTBaseView.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import UIKit

class CTBaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        remakeConstraints()
    }

    @objc open dynamic func initUI() {
        backgroundColor = .white
    }

    @objc open dynamic func remakeConstraints() {}
}
