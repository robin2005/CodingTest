//
//  UIViewEx.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import UIKit

// MARK: - 绘制圆角

extension UIView {
    // 添加4个不同大小的圆角
    func addCorner(_ cornerRadius: CGFloat) {
        self.addCorner(cornerRadii: CornerRadii(topLeft: cornerRadius,
                                                topRight: cornerRadius,
                                                bottomLeft: cornerRadius,
                                                bottomRight: cornerRadius))
    }
    
    func addCorner(cornerRadii: CornerRadii) {
        let path = self.createPathWithRoundedRect(bounds: self.bounds, cornerRadii: cornerRadii)
        let shapLayer = CAShapeLayer()
        shapLayer.frame = self.bounds
        shapLayer.path = path
        self.layer.mask = shapLayer
    }
    
    func getCornerLayer(_ cornerRadius: CGFloat) -> CAShapeLayer {
        let cornerRadii = CornerRadii(cornerRadius: cornerRadius)
        let path = self.createPathWithRoundedRect(bounds: self.bounds, cornerRadii: cornerRadii)
        let shapLayer = CAShapeLayer()
        shapLayer.frame = self.bounds
        shapLayer.path = path
        return shapLayer
    }
    
    // 各圆角大小
    struct CornerRadii {
        var topLeft: CGFloat = 0
        var topRight: CGFloat = 0
        var bottomLeft: CGFloat = 0
        var bottomRight: CGFloat = 0
        
        init(cornerRadius: CGFloat) {
            self.topLeft = cornerRadius
            self.topRight = cornerRadius
            self.bottomLeft = cornerRadius
            self.bottomRight = cornerRadius
        }
        
        init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
        }
    }
    
    // 切圆角函数绘制线条
    func createPathWithRoundedRect(bounds: CGRect, cornerRadii: CornerRadii) -> CGPath {
        let minX = bounds.minX
        let minY = bounds.minY
        let maxX = bounds.maxX
        let maxY = bounds.maxY
        
        // 获取四个圆心
        let topLeftCenterX = minX + cornerRadii.topLeft
        let topLeftCenterY = minY + cornerRadii.topLeft
        
        let topRightCenterX = maxX - cornerRadii.topRight
        let topRightCenterY = minY + cornerRadii.topRight
        
        let bottomLeftCenterX = minX + cornerRadii.bottomLeft
        let bottomLeftCenterY = maxY - cornerRadii.bottomLeft
        
        let bottomRightCenterX = maxX - cornerRadii.bottomRight
        let bottomRightCenterY = maxY - cornerRadii.bottomRight
        
        // 虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
        let path = CGMutablePath()
        // 顶 左
        path.addArc(center: CGPoint(x: topLeftCenterX, y: topLeftCenterY), radius: cornerRadii.topLeft, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 3 / 2, clockwise: false)
        // 顶右
        path.addArc(center: CGPoint(x: topRightCenterX, y: topRightCenterY), radius: cornerRadii.topRight, startAngle: CGFloat.pi * 3 / 2, endAngle: 0, clockwise: false)
        // 底右
        path.addArc(center: CGPoint(x: bottomRightCenterX, y: bottomRightCenterY), radius: cornerRadii.bottomRight, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: false)
        // 底左
        path.addArc(center: CGPoint(x: bottomLeftCenterX, y: bottomLeftCenterY), radius: cornerRadii.bottomLeft, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: false)
        path.closeSubpath()
        
        return path
    }
}
