//
//  UIScreenEx.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import Foundation
import UIKit

// MARK: UIScreen计算宽高

public extension UIScreen {
    /// 屏幕尺寸
    static var mainBounds: CGRect {
        return UIScreen.main.bounds
    }

    /// 宽度 Scale
    static var widthScale: CGFloat {
        return UIScreen.main.bounds.width / 375.0
    }

    /// 高度 Scale
    static var heightScale: CGFloat {
        return UIScreen.main.bounds.height / 667.0
    }

    /// 宽度
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }

    /// 高度
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }

    /// 通过高度判断是不是 iPhone X 系列（X, XS 高度812，宽度375；XR，XS Max 高度896，宽度414）
    // 获取底部的安全距离，全面屏手机为34pt，非全面屏手机为0pt
    static var isIPhoneX: Bool {
        let keyWindow: UIWindow? = {
            if #available(iOS 13.0, *) {
                return UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
                    .compactMap { $0 as? UIWindowScene }.first?.windows
                    .filter { $0.isKeyWindow }.first
            } else {
                return UIApplication.shared.keyWindow!
            }
        }()
        let bottomSafeAreaHeight = keyWindow?.safeAreaInsets.bottom ?? 0.0
        return bottomSafeAreaHeight > 0
    }

    /// iphoneX 顶部的高度
    static var topStatus: CGFloat {
        return UIScreen.top + 20
    }

    /// iphoneX 顶部的高度
    static var top: CGFloat { ////适配iPhoneX
        return UIScreen.isIPhoneX ? 24 : 0 // 24是 x 比普通屏幕多的部分
    }

    /// iphoneX 带导航条顶部的高度
    static var topAndNavBar: CGFloat {
        return UIScreen.top + 64
    }

    /// iphoneX 底部的高度
    static var bottom: CGFloat {
        return UIScreen.isIPhoneX ? 34 : 0
    }

    /// 底部 + tabBar 的高度
    static var bottomAndTabBar: CGFloat {
        return UIScreen.bottom + 49
    }

    /// 除去导航栏的高度
    static var heightExceptNavBar: CGFloat {
        return UIScreen.height - UIScreen.topAndNavBar
    }

    /// 除去底部的高度
    static var heightExceptBottom: CGFloat {
        return UIScreen.height - UIScreen.bottom
    }

    /// 除去导航栏和底部的高度
    static var heightExceptNavBarAndBottom: CGFloat {
        return UIScreen.height - UIScreen.bottom - UIScreen.topAndNavBar
    }

    /// 除去导航栏、底部和 tabbar 的高度
    static var heightExceptNavBarAndBottomAndTabbar: CGFloat {
        return UIScreen.height - UIScreen.bottomAndTabBar - UIScreen.topAndNavBar
    }
}
