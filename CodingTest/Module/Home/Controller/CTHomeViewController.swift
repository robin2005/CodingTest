//
//  CTHomeViewController.swift
//  CodingTest
//
//  Created by jdm on 10/31/24.
//

import GoogleMaps
import GoogleNavigation
import Toast
import UIKit

class CTHomeViewController: CTBaseViewController {
    lazy var viewModel = CTHomeViewModel()
    lazy var itemView = CTHomeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configItemView()
        configEventSubscribe()
        self.viewModel.showTermsAndConditionsDialogIfNeeded()
        self.viewModel.startNotifier()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    deinit {
        self.viewModel.stopNotifier()
    }
}

extension CTHomeViewController {
    func configItemView() {
        self.view.addSubview(self.itemView)
        self.itemView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}

extension CTHomeViewController {
    func configEventSubscribe() {
        self.viewModel.eventModel.subscribe(onNext: { [weak self] event in
            self?.configViewModelEvent(event)
        }).disposed(by: rx.disposeBag)

        self.itemView.eventModel.subscribe(onNext: { [weak self] event in
            self?.configViewEvent(event)
        }).disposed(by: rx.disposeBag)

        self.viewModel.netStatus.bind(to: self.itemView.netStatus).disposed(by: rx.disposeBag)
    }

    func configViewModelEvent(_ event: CTHomeViewModelEventType) {
        switch event {
            case .showCurLocation:
                self.itemView.showCurLocation()
            default: break
        }
    }

    func configViewEvent(_ event: CTHomeViewEventType) {
        switch event {
            case .goGuidanceDetail(let legs):
                self.navigationController?.pushViewController(CTGuidanceDetailViewController(legs), animated: true)
            case .reverseGeocodeByDestination(let coordinate):
                self.reverseGeocodeByDestination(coordinate)

            case .reverseGeocodeByOrigin(let coordinate):
                self.reverseGeocodeByOrigin(coordinate)
            case .travelModeChange:
                self.travelModeChange()
            default: break
        }
    }

    func reverseGeocodeByDestination(_ coordinate: CLLocationCoordinate2D) {
        self.viewModel.reverseGeocodeCoordinate(coordinate) { response, _ in
            guard let address = response?.firstResult() else {
                self.view.makeToast("network is unreachable")
                return
            }
            self.itemView.selectAddress = address
        }
    }

    func reverseGeocodeByOrigin(_ coordinate: CLLocationCoordinate2D) {
        self.viewModel.reverseGeocodeCoordinate(coordinate) { response, _ in
            guard let address = response?.firstResult() else {
                self.view.makeToast("network is unreachable")
                return
            }
            self.itemView.originAddress = address
        }
    }

    func travelModeChange() {
        let selectIndex = self.itemView.travelMode.value.rawValue
        let optionMenu = UIAlertController(title: nil, message: "Choose travel mode", preferredStyle: .actionSheet)
        let titles = ["Driving routes", "Cycling routes", "Walking routes", "Two-wheeler routes", "Taxicab routes"]
        for index in 0 ..< titles.count {
            let title = "\(titles[index])\(index == selectIndex ? "✅" : "")"
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.itemView.travelMode.accept(GMSNavigationTravelMode(rawValue: index) ?? .walking)
            }
            optionMenu.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true)
    }
}
