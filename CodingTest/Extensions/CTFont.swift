//
//  CTFont.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import UIKit

public enum CTFont {
    case title13
    case title16
    case title17
    case title18

    var font: UIFont? {
        switch self {
        case .title13: return UIFont.systemFont(ofSize: 13)
        case .title16: return UIFont.systemFont(ofSize: 16)
        case .title17: return UIFont.systemFont(ofSize: 17)
        case .title18: return UIFont.systemFont(ofSize: 18)
        }
    }
}
