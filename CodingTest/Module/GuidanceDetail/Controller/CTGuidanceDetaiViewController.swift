//
//  CTGuidanceDetailViewController.swift
//  CodingTest
//
//  Created by jdm on 11/1/24.
//

import GoogleMaps
import GoogleNavigation
import UIKit

class CTGuidanceDetailViewController: CTBaseViewController {
    lazy var itemView = CTGuidanceDetailView()
    var detailModel: CTGuidanceDetailModel?

    convenience init(_ detailModel: CTGuidanceDetailModel) {
        self.init(nibName: nil, bundle: nil)
        self.detailModel = detailModel
    }

    override func viewDidLoad() {
        title = "Summary of the trip"
        super.viewDidLoad()
        configItemView()
        configEventSubscribe()
        self.itemView.detailModel = self.detailModel
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension CTGuidanceDetailViewController {
    func configItemView() {
        self.view.addSubview(self.itemView)
        self.itemView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}

extension CTGuidanceDetailViewController {
    func configEventSubscribe() {
        self.itemView.eventModel.subscribe(onNext: { [weak self] event in
            self?.configViewEvent(event)
        }).disposed(by: rx.disposeBag)
    }

    func configViewEvent(_ event: CTGuidanceDetailViewEventType) {
        switch event {
        case .back:
            self.navigationController?.popViewController(animated: true)
        default: break
        }
    }
}
