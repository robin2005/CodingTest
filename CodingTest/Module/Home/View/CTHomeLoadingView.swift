//
//  CTHomeLoadingView.swift
//  CodingTest
//
//  Created by jdm on 11/2/24.
//

import UIKit

class CTHomeLoadingView: CTBaseView {
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.width, height: 120)
    }
}

extension CTHomeLoadingView {
    override func initUI() {
        super.initUI()
        isHidden = true
        backgroundColor = Asset.Colors.viewSubBgColor.color
        activityIndicator.color = Asset.Colors.textColor.color
        addSubview(activityIndicator)
    }

    override func remakeConstraints() {
        super.remakeConstraints()
        activityIndicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
        addCorner(cornerRadii: CornerRadii(topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0))
    }

    func startAnimating() {
        isHidden = false
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        isHidden = true
        activityIndicator.stopAnimating()
    }
}
