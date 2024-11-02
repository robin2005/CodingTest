//
//  CTBaseViewController.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import NSObject_Rx
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class CTBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

   
}
